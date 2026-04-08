import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  bool _isLogin = true;
  bool get isLogin => _isLogin;

  void toggleMode() {
    _isLogin = !_isLogin;
    notifyListeners();
  }

  void login() {
    // Acá se loguearia el usuario
  }

  void register() {
    // Acá se registraria el usuario
  }
}
