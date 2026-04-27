import 'package:flutter/material.dart';

class MapMarkers extends StatelessWidget {
  const MapMarkers({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: MediaQuery.of(context).size.height * 0.25,
          left: MediaQuery.of(context).size.width * 0.35,
          child: _buildMarker(Icons.car_crash, Colors.red.shade700),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.45,
          left: MediaQuery.of(context).size.width * 0.7,
          child: _buildMarker(Icons.security, Colors.blue.shade800),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.55,
          left: MediaQuery.of(context).size.width * 0.25,
          child: _buildMarker(Icons.medical_services, Colors.indigo.shade500),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.65,
          left: MediaQuery.of(context).size.width * 0.6,
          child: _buildMarker(Icons.construction, Colors.brown.shade600),
        ),
      ],
    );
  }

  Widget _buildMarker(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 22),
    );
  }
}
