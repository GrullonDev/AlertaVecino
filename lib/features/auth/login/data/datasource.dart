import 'package:neighbour_alert/core/api/api_client.dart';
import 'package:neighbour_alert/core/api/api_exception.dart';
import 'package:neighbour_alert/features/auth/login/model/login_error.dart';
import 'package:neighbour_alert/features/auth/login/model/login_request.dart';
import 'package:neighbour_alert/features/auth/login/model/login_response.dart';

abstract class DataSource {
  Future<LoginResponse> login(LoginRequest request);
}

class DataSourceImpl implements DataSource {
  DataSourceImpl({required ApiClient apiClient}) : _api = apiClient;

  final ApiClient _api;

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final json = await _api.post(
        '/auth/login',
        body: request.toJson(),
      );
      return LoginResponse.fromJson(json);
    } on ApiException catch (e) {
      throw LoginException(
        _mapErrorType(e.type),
        statusCode: e.statusCode,
        serverMessage: e.serverMessage,
      );
    }
  }

  static LoginErrorType _mapErrorType(ApiErrorType type) => switch (type) {
        ApiErrorType.validation => LoginErrorType.validation,
        ApiErrorType.unauthorized ||
        ApiErrorType.forbidden =>
          LoginErrorType.invalidCredentials,
        ApiErrorType.notFound => LoginErrorType.notFound,
        ApiErrorType.conflict => LoginErrorType.conflict,
        ApiErrorType.server => LoginErrorType.server,
        ApiErrorType.timeout => LoginErrorType.timeout,
        ApiErrorType.connection => LoginErrorType.connection,
        ApiErrorType.badResponse => LoginErrorType.badResponse,
        ApiErrorType.unknown => LoginErrorType.unknown,
      };
}
