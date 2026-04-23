import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_model.dart';

abstract class AuthRepository {
  Future<bool> login(String email, String password);
  Future<bool> register(String name, String email, String password);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
  Future<bool> upgradeToPro(String userId);
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
          isPro: userData['isPro'] ?? false,
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
        'isPro': false, // Por defecto el usuario no es Pro
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

  @override
  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userStr = prefs.getString('current_user');
    if (userStr != null) {
      return UserModel.fromJson(jsonDecode(userStr));
    }
    return null;
  }

  @override
  Future<bool> upgradeToPro(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await _getUsersDb();

    // Buscamos al usuario por su ID
    String? userEmail;
    for (var entry in users.entries) {
      if (entry.value['id'] == userId) {
        userEmail = entry.key;
        break;
      }
    }

    if (userEmail != null) {
      users[userEmail]['isPro'] = true;
      await prefs.setString('app_database_users', jsonEncode(users));

      final userStr = prefs.getString('current_user');
      if (userStr != null) {
        final currentUser = jsonDecode(userStr);
        if (currentUser['id'] == userId) {
          currentUser['isPro'] = true;
          await prefs.setString('current_user', jsonEncode(currentUser));
        }
      }
      return true;
    }
    return false;
  }
}

class AuthService {
  final AuthRepository _repository = LocalAuthRepository();

  Future<bool> login(String email, String password) => _repository.login(email, password);
  Future<bool> register(String name, String email, String password) => _repository.register(name, email, password);
  Future<void> logout() => _repository.logout();
  Future<UserModel?> getCurrentUser() => _repository.getCurrentUser();
  Future<bool> upgradeToPro(String userId) => _repository.upgradeToPro(userId);
}
