import 'package:neighbour_alert/features/maps/data/map_datasource.dart';
import 'package:neighbour_alert/features/maps/models/map_marker_item.dart';

abstract class MapRepository {
  Future<List<MapMarkerItem>> fetchMarkers();
}

class MapRepositoryImpl implements MapRepository {
  MapRepositoryImpl({required MapDataSource dataSource})
      : _dataSource = dataSource;

  final MapDataSource _dataSource;

  @override
  Future<List<MapMarkerItem>> fetchMarkers() => _dataSource.fetchMarkers();
}
