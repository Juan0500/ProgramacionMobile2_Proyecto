  import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_model.dart';

class AuthService {
  
  Future<bool> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    
    final usersString = prefs.getString('users_db') ?? '{}';
    Map<String, dynamic> users = jsonDecode(usersString);

    if (users.containsKey(email)) {
      if (users[email]['password'] == password) {
        await prefs.setString('current_user', jsonEncode(users[email]));
        return true;
      }
    }
    return false;
  }

  Future<bool> register(String name, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final usersString = prefs.getString('users_db') ?? '{}';
    Map<String, dynamic> users = jsonDecode(usersString);

    // validar si ya existe
    if (users.containsKey(email)) {
      return false; 
    }

    // simulamos guardar en la bdd
    users[email] = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': name,
      'email': email,
      'password': password,
    };

    await prefs.setString('users_db', jsonEncode(users));
    return true;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user');
  }
}