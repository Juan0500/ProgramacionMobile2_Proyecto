import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class PaymentViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final List<String> benefits = [
    'Hábitos ilimitados',
    'Geocercas activas',
    'Estadísticas avanzadas',
    'Sincronización en la nube',
    'Soporte prioritario'
  ];

  Future<bool> processPayment() async {
    _isLoading = true;
    notifyListeners();

    // Simulamos API de pagos
    await Future.delayed(const Duration(seconds: 2));

    final user = await _authService.getCurrentUser();
    if (user != null) {
      await _authService.upgradeToPro(user.id);
    }

    _isLoading = false;
    notifyListeners();
    
    return true; 
  }
}