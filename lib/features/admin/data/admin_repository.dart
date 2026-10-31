import 'package:neighbour_alert/features/admin/data/admin_datasource.dart';
import 'package:neighbour_alert/features/admin/data/admin_user.dart';

abstract class AdminRepository {
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

class AdminRepositoryImpl implements AdminRepository {
  AdminRepositoryImpl({required AdminDataSource dataSource})
      : _dataSource = dataSource;

  final AdminDataSource _dataSource;

  @override
  Future<List<AdminUser>> listUsers({String? status}) =>
      _dataSource.listUsers(status: status);

  @override
  Future<void> approveUser(String id) => _dataSource.approveUser(id);

  @override
  Future<void> rejectUser(String id, {String? reason}) =>
      _dataSource.rejectUser(id, reason: reason);

  @override
  Future<void> deleteUser(String id) => _dataSource.deleteUser(id);

  @override
  Future<Map<String, dynamic>> createAnnouncement({
    required String authorId,
    required String title,
    required String body,
    String category = 'info',
  }) =>
      _dataSource.createAnnouncement(
        authorId: authorId,
        title: title,
        body: body,
        category: category,
      );
}
