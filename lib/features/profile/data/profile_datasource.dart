import 'package:neighbour_alert/core/api/api_client.dart';
import 'package:neighbour_alert/features/auth/login/model/user.dart';

abstract class ProfileDataSource {
  Future<User> fetchMe();
}

class ProfileDataSourceImpl implements ProfileDataSource {
  ProfileDataSourceImpl({required ApiClient apiClient}) : _api = apiClient;

  final ApiClient _api;

  @override
  Future<User> fetchMe() async {
    final json = await _api.get('/v1/auth/me');
    final userData = json['user'] as Map<String, dynamic>;
    return User.fromJson(userData);
  }
}
