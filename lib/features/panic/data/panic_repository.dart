import 'package:neighbour_alert/features/panic/data/panic_datasource.dart';
import 'package:neighbour_alert/features/panic/models/trigger_result.dart';

abstract class PanicRepository {
  Future<TriggerResult> trigger({
    required double latitude,
    required double longitude,
    required String emergencyType,
    String? description,
  });

  Future<String?> fetchStatus(String alertId);
}

class PanicRepositoryImpl implements PanicRepository {
  PanicRepositoryImpl({required PanicDataSource dataSource})
      : _dataSource = dataSource;

  final PanicDataSource _dataSource;

  @override
  Future<TriggerResult> trigger({
    required double latitude,
    required double longitude,
    required String emergencyType,
    String? description,
  }) =>
      _dataSource.trigger(
        latitude: latitude,
        longitude: longitude,
        emergencyType: emergencyType,
        description: description,
      );

  @override
  Future<String?> fetchStatus(String alertId) =>
      _dataSource.fetchStatus(alertId);
}
