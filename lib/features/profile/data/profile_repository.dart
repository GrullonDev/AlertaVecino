import 'package:neighbour_alert/features/auth/login/model/user.dart';
import 'package:neighbour_alert/features/profile/data/profile_datasource.dart';

abstract class ProfileRepository {
  Future<User> fetchMe();
}

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({required ProfileDataSource dataSource})
      : _dataSource = dataSource;

  final ProfileDataSource _dataSource;

  @override
  Future<User> fetchMe() => _dataSource.fetchMe();
}
