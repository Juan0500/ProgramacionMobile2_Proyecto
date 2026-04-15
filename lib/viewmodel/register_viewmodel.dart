import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  String errorMessage = '';

  Future<bool> register(String name, String email, String password) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      bool success = await _authService.register(name, email, password);

      if (!success) {
        errorMessage = 'Este correo ya está registrado';
      }

      isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      isLoading = false;
      errorMessage = 'Error al crear la cuenta';
      notifyListeners();
      return false;
    }
  }
}
