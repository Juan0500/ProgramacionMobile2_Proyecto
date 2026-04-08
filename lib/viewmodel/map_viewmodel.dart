import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class MapViewModel extends ChangeNotifier {
  // Montevideo, Uruguay
  final LatLng initialPosition = const LatLng(-34.9011, -56.1645);
  final double initialZoom = 14.0;

  final Map<String, LatLng> markers = {
    'casa': const LatLng(-34.9011, -56.1645),
    'parque': const LatLng(-34.9056, -56.1818),
  };
}
