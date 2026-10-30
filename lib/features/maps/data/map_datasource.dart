import 'package:latlong2/latlong.dart';
import 'package:neighbour_alert/core/api/api_client.dart';
import 'package:neighbour_alert/features/maps/models/map_marker_item.dart';

abstract class MapDataSource {
  Future<List<MapMarkerItem>> fetchMarkers();
}

class MapDataSourceImpl implements MapDataSource {
  MapDataSourceImpl({required ApiClient apiClient}) : _api = apiClient;

  final ApiClient _api;

  @override
  Future<List<MapMarkerItem>> fetchMarkers() async {
    final json = await _api.get('/v1/panic/active');
    final list = json['alerts'] as List<dynamic>;
    return [
      for (final item in list)
        _parseMarker(item as Map<String, dynamic>),
    ];
  }

  static MapMarkerItem _parseMarker(Map<String, dynamic> json) {
    final lat = (json['latitude'] as num).toDouble();
    final lng = (json['longitude'] as num).toDouble();
    final type = json['emergencyType'] as String? ?? 'other';
    final status = json['status'] as String? ?? '';
    final createdAt = DateTime.parse(json['createdAt'] as String);
    final user = json['user'] as Map<String, dynamic>?;
    final house = user?['house'] as String? ?? '';

    return MapMarkerItem(
      id: json['id'] as String,
      title: _typeLabel(type),
      description: json['description'] as String? ?? house,
      category: _toMarkerCategory(type),
      position: LatLng(lat, lng),
      timeAgo: _timeAgo(createdAt),
      isActive: status != 'resolved' && status != 'cancelled',
    );
  }

  static MarkerCategory _toMarkerCategory(String type) => switch (type) {
        'intrusion' || 'robbery' || 'suspicious' => MarkerCategory.incident,
        _ => MarkerCategory.panic,
      };

  static String _typeLabel(String type) => switch (type) {
        'medical' => 'Emergencia médica',
        'fire' => 'Incendio',
        'intrusion' => 'Intrusión',
        'robbery' => 'Robo',
        'suspicious' => 'Actividad sospechosa',
        _ => 'Alerta',
      };

  static String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Ahora';
    if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Hace ${diff.inHours}h';
    return 'Hace ${diff.inDays}d';
  }
}
