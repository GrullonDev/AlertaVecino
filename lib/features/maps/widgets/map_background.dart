import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:neighbour_alert/config/app_theme.dart';
import 'package:neighbour_alert/features/maps/models/map_marker_item.dart';

class MapBackground extends StatelessWidget {
  const MapBackground({
    super.key,
    required this.controller,
    required this.markers,
    required this.onMarkerTap,
    required this.onTap,
  });

  final MapController controller;
  final List<MapMarkerItem> markers;
  final ValueChanged<MapMarkerItem> onMarkerTap;
  final VoidCallback onTap;

  static const sanMiguelPetapa = LatLng(14.5260, -90.5560);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final tileLayer = TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'com.alertavecino.app',
    );

    final map = FlutterMap(
      mapController: controller,
      options: MapOptions(
        initialCenter: sanMiguelPetapa,
        initialZoom: 15.0,
        minZoom: 10,
        maxZoom: 18,
        onTap: (_, _) => onTap(),
      ),
      children: [
        tileLayer,
        MarkerLayer(
          markers: markers.map((item) => _buildMarker(item, isDark)).toList(),
        ),
      ],
    );

    if (isDark) {
      return ColorFiltered(
        colorFilter: const ColorFilter.matrix([
          -0.8,
          0,
          0,
          0,
          230,
          0,
          -0.8,
          0,
          0,
          230,
          0,
          0,
          -0.8,
          0,
          230,
          0,
          0,
          0,
          1,
          0,
        ]),
        child: map,
      );
    }

    return map;
  }

  Marker _buildMarker(MapMarkerItem item, bool isDark) {
    final (color, icon) = switch (item.category) {
      MarkerCategory.panic => (
        isDark ? AppColors.panicDark : AppColors.panic,
        Icons.warning_amber_rounded,
      ),
      MarkerCategory.gate => (
        isDark ? AppColors.infoDark : AppColors.info,
        Icons.door_sliding_outlined,
      ),
      MarkerCategory.incident => (
        isDark ? AppColors.successDark : AppColors.success,
        Icons.report_outlined,
      ),
    };

    return Marker(
      point: item.position,
      width: 42,
      height: 42,
      child: GestureDetector(
        onTap: () => onMarkerTap(item),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.6),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.4),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}
