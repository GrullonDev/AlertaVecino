import 'package:neighbour_alert/core/api/api_client.dart';
import 'package:neighbour_alert/features/alerts/models/alert_history_item.dart';

abstract class AlertsDataSource {
  Future<List<AlertHistoryItem>> fetchHistory();
  Future<List<AlertHistoryItem>> fetchActive();
}

class AlertsDataSourceImpl implements AlertsDataSource {
  AlertsDataSourceImpl({required ApiClient apiClient}) : _api = apiClient;

  final ApiClient _api;

  @override
  Future<List<AlertHistoryItem>> fetchHistory() async {
    final json = await _api.get('/v1/panic/history');
    final list = json['alerts'] as List<dynamic>;
    return [
      for (final item in list)
        _parseAlert(item as Map<String, dynamic>),
    ];
  }

  @override
  Future<List<AlertHistoryItem>> fetchActive() async {
    final json = await _api.get('/v1/panic/active');
    final list = json['alerts'] as List<dynamic>;
    return [
      for (final item in list)
        _parseAlert(item as Map<String, dynamic>),
    ];
  }

  static AlertHistoryItem _parseAlert(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;
    final firstName = user?['firstName'] as String? ?? '';
    final lastName = user?['lastName'] as String? ?? '';
    final reportedBy = '$firstName $lastName'.trim();
    final house = user?['house'] as String?;

    return AlertHistoryItem(
      id: json['id'] as String,
      category: _parseCategory(json['emergencyType'] as String? ?? ''),
      status: _parseStatus(json['status'] as String? ?? ''),
      title: json['emergencyType'] as String? ?? '',
      location: house ?? user?['residency'] as String? ?? '',
      reportedAt: DateTime.parse(json['createdAt'] as String),
      duration: '',
      description: json['description'] as String? ?? '',
      reportedBy: reportedBy.isEmpty ? null : reportedBy,
    );
  }

  static AlertCategory _parseCategory(String type) => switch (type) {
        'medical' => AlertCategory.medical,
        'fire' => AlertCategory.fire,
        'robbery' || 'intrusion' || 'suspicious' => AlertCategory.security,
        _ => AlertCategory.general,
      };

  static AlertStatus _parseStatus(String status) => switch (status) {
        'registered' || 'notified' || 'acknowledged' || 'responding' =>
          AlertStatus.active,
        'resolved' => AlertStatus.resolved,
        'cancelled' => AlertStatus.falseAlarm,
        _ => AlertStatus.handled,
      };
}
