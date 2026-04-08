import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../viewmodel/map_viewmodel.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MapViewModel(),
      child: Scaffold(
        body: Stack(
          children: [
            Consumer<MapViewModel>(
              builder: (context, viewModel, child) {
                return FlutterMap(
                  options: MapOptions(
                    initialCenter: viewModel.initialPosition,
                    initialZoom: viewModel.initialZoom,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.mobile2_proyecto',
                    ),
                    MarkerLayer(
                      markers: viewModel.markers.entries.map((entry) {
                        return Marker(
                          point: entry.value,
                          width: 40,
                          height: 40,
                          child: Icon(
                            entry.key == 'casa' ? Icons.home : Icons.location_on,
                            color: AppTheme.primary,
                            size: 32,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                );
              },
            ),
            _buildTopOverlay(context),
            _buildBottomOverlay(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTopOverlay(BuildContext context) {
    return Positioned(
      top: 60,
      left: 20,
      right: 20,
      child: Row(
        children: [
          _buildCircleButton(Icons.arrow_back, () => Navigator.pop(context)),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: AppTheme.outline, size: 20),
                  const SizedBox(width: 8),
                  Text('Buscar en Montevideo...',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.outline)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomOverlay(BuildContext context) {
    return Positioned(
      bottom: 40,
      left: 20,
      right: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildCircleButton(Icons.my_location, () {}, isPrimary: true),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Hábito Cercano', style: Theme.of(context).textTheme.labelSmall),
                    const Icon(Icons.close, size: 16, color: AppTheme.outline),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.directions_run, color: AppTheme.primary),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Running 5km', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
                          Text('Parque Rodó • 250m',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.outline)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('¡IR!',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton(IconData icon, VoidCallback onPressed, {bool isPrimary = false}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isPrimary ? AppTheme.primary : Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
          ],
        ),
        child: Icon(icon, color: isPrimary ? Colors.white : AppTheme.onSurface, size: 24),
      ),
    );
  }
}
