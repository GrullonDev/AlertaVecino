import 'package:neighbour_alert/core/api/api_client.dart';
import 'package:neighbour_alert/core/api/api_exception.dart';
import 'package:neighbour_alert/features/auth/register/model/register_error.dart';
import 'package:neighbour_alert/features/auth/register/model/registration_draft.dart';

abstract class RegisterDataSource {
  Future<void> register(
    RegistrationDraft draft, {
    String? residency,
    String? house,
  });
}

class RegisterDataSourceImpl implements RegisterDataSource {
  RegisterDataSourceImpl({required ApiClient apiClient}) : _api = apiClient;

  final ApiClient _api;

  @override
  Future<void> register(
    RegistrationDraft draft, {
    String? residency,
    String? house,
  }) async {
    try {
      await _api.post(
        '/auth/register',
        body: {
          'fullName': draft.fullName,
          'email': draft.email,
          'phone': draft.phone,
          'password': draft.password,
          if (residency != null && residency.isNotEmpty) 'residency': residency,
          if (house != null && house.isNotEmpty) 'house': house,
        },
      );
    } on ApiException catch (e) {
      throw RegisterException(
        _mapErrorType(e.type),
        statusCode: e.statusCode,
        serverMessage: e.serverMessage,
      );
    }
  }

  static RegisterErrorType _mapErrorType(ApiErrorType type) => switch (type) {
        ApiErrorType.validation => RegisterErrorType.validation,
        ApiErrorType.conflict => RegisterErrorType.conflict,
        ApiErrorType.server => RegisterErrorType.server,
        ApiErrorType.timeout => RegisterErrorType.timeout,
        ApiErrorType.connection => RegisterErrorType.connection,
        ApiErrorType.badResponse => RegisterErrorType.badResponse,
        _ => RegisterErrorType.unknown,
      };
}
