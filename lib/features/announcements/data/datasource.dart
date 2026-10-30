import 'package:neighbour_alert/core/api/api_client.dart';
import 'package:neighbour_alert/core/api/api_exception.dart';
import 'package:neighbour_alert/features/announcements/data/announcements_error.dart';
import 'package:neighbour_alert/features/announcements/models/announcement.dart';

abstract class AnnouncementsDataSource {
  Future<List<Announcement>> list({String? category});
}

class AnnouncementsDataSourceImpl implements AnnouncementsDataSource {
  AnnouncementsDataSourceImpl({required ApiClient apiClient})
      : _api = apiClient;

  final ApiClient _api;

  @override
  Future<List<Announcement>> list({String? category}) async {
    try {
      final path = category != null && category.isNotEmpty
          ? '/v1/announcements?category=$category'
          : '/v1/announcements';
      final json = await _api.get(path);
      final items = json['announcements'] as List<dynamic>? ?? [];
      return items
          .cast<Map<String, dynamic>>()
          .map(Announcement.fromJson)
          .toList();
    } on ApiException catch (e) {
      throw AnnouncementsException(
        _mapErrorType(e.type),
        statusCode: e.statusCode,
      );
    }
  }

  static AnnouncementsErrorType _mapErrorType(ApiErrorType type) =>
      switch (type) {
        ApiErrorType.unauthorized => AnnouncementsErrorType.unauthorized,
        ApiErrorType.server => AnnouncementsErrorType.server,
        ApiErrorType.timeout => AnnouncementsErrorType.timeout,
        ApiErrorType.connection => AnnouncementsErrorType.connection,
        ApiErrorType.badResponse => AnnouncementsErrorType.badResponse,
        _ => AnnouncementsErrorType.unknown,
      };
}
