import 'package:neighbour_alert/features/auth/login/data/datasource.dart';
import 'package:neighbour_alert/features/auth/login/model/login_request.dart';
import 'package:neighbour_alert/features/auth/login/model/login_response.dart';

abstract class Repository {
  Future<LoginResponse> login(LoginRequest request);
}

class RepositoryImpl implements Repository {
  RepositoryImpl({required this.dataSource});
  final DataSource dataSource;

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    final result = dataSource.login(request);

    return result;
  }
}
