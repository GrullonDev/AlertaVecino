import 'package:neighbour_alert/features/alerts/data/alerts_datasource.dart';
import 'package:neighbour_alert/features/alerts/models/alert_history_item.dart';

abstract class AlertsRepository {
  Future<List<AlertHistoryItem>> fetchHistory();
  Future<List<AlertHistoryItem>> fetchActive();
}

class AlertsRepositoryImpl implements AlertsRepository {
  AlertsRepositoryImpl({required AlertsDataSource dataSource})
      : _dataSource = dataSource;

  final AlertsDataSource _dataSource;

  @override
  Future<List<AlertHistoryItem>> fetchHistory() =>
      _dataSource.fetchHistory();

  @override
  Future<List<AlertHistoryItem>> fetchActive() =>
      _dataSource.fetchActive();
}
