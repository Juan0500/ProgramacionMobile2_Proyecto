import 'package:flutter/material.dart';

class PaymentViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Podrías tener diferentes planes
  final List<String> benefits = [
    'Hábitos ilimitados',
    'Estadísticas avanzadas',
    'Sincronización en la nube',
    'Soporte prioritario'
  ];

  Future<bool> processPayment() async {
    _isLoading = true;
    notifyListeners();

    // Simulamos una llamada a una API de pagos (Stripe/MercadoPago)
    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();
    
    return true; 
  }
}