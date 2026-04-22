import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_model.dart';

abstract class AuthRepository {
  Future<bool> login(String email, String password);
  Future<bool> register(String name, String email, String password);
  Future<void> logout();
}

class LocalAuthRepository implements AuthRepository {
  Future<Map<String, dynamic>> _getUsersDb() async {
    final prefs = await SharedPreferences.getInstance();
    final usersString = prefs.getString('app_database_users') ?? '{}';
    return jsonDecode(usersString);
  }

  @override
  Future<bool> login(String email, String password) async {
    final users = await _getUsersDb();

    if (users.containsKey(email)) {
      final userData = users[email];
      
      if (userData['password'] == password) {
        final prefs = await SharedPreferences.getInstance();
        final user = UserModel(
          id: userData['id'],
          name: userData['name'],
          email: userData['email'],
        );
        await prefs.setString('current_user', jsonEncode(user.toJson()));
        return true;
      }
    }
    
    return false;
  }

  @override
  Future<bool> register(String name, String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final users = await _getUsersDb();

      if (users.containsKey(email)) {
        return false;
      }

      final id = DateTime.now().millisecondsSinceEpoch.toString();
      users[email] = {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
      };

      await prefs.setString('app_database_users', jsonEncode(users));
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user');
  }
}

class AuthService {
  final AuthRepository _repository = LocalAuthRepository();

  Future<bool> login(String email, String password) async {
    return await _repository.login(email, password);
  }

  Future<bool> register(String name, String email, String password) async {
    return await _repository.register(name, email, password);
  }

  Future<void> logout() async {
    return await _repository.logout();
  }
}
