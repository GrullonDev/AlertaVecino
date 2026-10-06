import 'package:latlong2/latlong.dart';

enum MarkerCategory { panic, gate, incident }

class MapMarkerItem {
  const MapMarkerItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.position,
    required this.timeAgo,
    this.isActive = true,
  });

  final String id;
  final String title;
  final String description;
  final MarkerCategory category;
  final LatLng position;
  final String timeAgo;
  final bool isActive;
}
