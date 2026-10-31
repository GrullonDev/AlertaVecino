import 'package:neighbour_alert/core/api/api_client.dart';
import 'package:neighbour_alert/features/admin/data/admin_user.dart';

abstract class AdminDataSource {
  Future<List<AdminUser>> listUsers({String? status});
  Future<void> approveUser(String id);
  Future<void> rejectUser(String id, {String? reason});
  Future<void> deleteUser(String id);
  Future<Map<String, dynamic>> createAnnouncement({
    required String authorId,
    required String title,
    required String body,
    String category,
  });
}

class AdminDataSourceImpl implements AdminDataSource {
  AdminDataSourceImpl({required ApiClient apiClient}) : _api = apiClient;

  final ApiClient _api;

  @override
  Future<List<AdminUser>> listUsers({String? status}) async {
    final query = status != null ? '?status=$status' : '';
    final json = await _api.get('/v1/admin/users$query');
    final list = json['users'] as List<dynamic>? ?? [];
    return list
        .cast<Map<String, dynamic>>()
        .map(AdminUser.fromJson)
        .toList();
  }

  @override
  Future<void> approveUser(String id) async {
    await _api.post('/v1/admin/users/approve', body: {'id': id});
  }

  @override
  Future<void> rejectUser(String id, {String? reason}) async {
    await _api.post('/v1/admin/users/reject', body: {
      'id': id,
      // ignore: use_null_aware_elements
      if (reason != null) 'reason': reason,
    });
  }

  @override
  Future<void> deleteUser(String id) async {
    await _api.delete('/v1/admin/users/delete?id=$id');
  }

  @override
  Future<Map<String, dynamic>> createAnnouncement({
    required String authorId,
    required String title,
    required String body,
    String category = 'info',
  }) async {
    return _api.post('/v1/admin/announcements/create', body: {
      'author_id': authorId,
      'title': title,
      'body': body,
      'category': category,
    });
  }
}
