import 'package:neighbour_alert/core/api/api_client.dart';
import 'package:neighbour_alert/core/api/api_exception.dart';
import 'package:neighbour_alert/features/panic/models/trigger_result.dart';

abstract class PanicDataSource {
  Future<TriggerResult> trigger({
    required double latitude,
    required double longitude,
    required String emergencyType,
    String? description,
  });

  Future<String?> fetchStatus(String alertId);
}

class PanicDataSourceImpl implements PanicDataSource {
  PanicDataSourceImpl({required ApiClient apiClient}) : _api = apiClient;

  final ApiClient _api;

  @override
  Future<TriggerResult> trigger({
    required double latitude,
    required double longitude,
    required String emergencyType,
    String? description,
  }) async {
    try {
      final json = await _api.post(
        '/v1/panic/trigger',
        body: {
          'latitude': latitude,
          'longitude': longitude,
          'emergency_type': emergencyType,
          'description': ?description,
        },
      );
      final alert = json['alert'] as Map<String, dynamic>;
      return TriggerResult(
        alertId: alert['id'] as String,
        status: alert['status'] as String,
      );
    } on ApiException catch (e) {
      final errorMsg = switch (e.type) {
        ApiErrorType.timeout => 'timeout',
        ApiErrorType.connection => 'connection',
        _ => 'Server error: ${e.statusCode}',
      };
      return TriggerResult(error: errorMsg);
    }
  }

  @override
  Future<String?> fetchStatus(String alertId) async {
    try {
      final json = await _api.get('/v1/panic/$alertId/status');
      return json['status'] as String?;
    } catch (_) {
      return null;
    }
  }
}
