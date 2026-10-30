import 'package:neighbour_alert/core/api/api_client.dart';
import 'package:neighbour_alert/core/api/api_exception.dart';
import 'package:neighbour_alert/features/auth/complete_profile/model/complete_profile_error.dart';

abstract class CompleteProfileDataSource {
  Future<void> completeProfile({
    required String token,
    required String userId,
    required String residency,
    required String house,
  });
}

class CompleteProfileDataSourceImpl implements CompleteProfileDataSource {
  CompleteProfileDataSourceImpl({required ApiClient apiClient})
      : _api = apiClient;

  final ApiClient _api;

  @override
  Future<void> completeProfile({
    required String token,
    required String userId,
    required String residency,
    required String house,
  }) async {
    try {
      await _api.post(
        '/auth/complete-profile',
        body: {
          'id': userId,
          'residency': residency,
          'house': house,
        },
      );
    } on ApiException catch (e) {
      throw CompleteProfileException(
        _mapErrorType(e.type),
        statusCode: e.statusCode,
        serverMessage: e.serverMessage,
      );
    }
  }

  static CompleteProfileErrorType _mapErrorType(ApiErrorType type) =>
      switch (type) {
        ApiErrorType.validation => CompleteProfileErrorType.validation,
        ApiErrorType.unauthorized => CompleteProfileErrorType.unauthorized,
        ApiErrorType.notFound => CompleteProfileErrorType.notFound,
        ApiErrorType.server => CompleteProfileErrorType.server,
        ApiErrorType.timeout => CompleteProfileErrorType.timeout,
        ApiErrorType.connection => CompleteProfileErrorType.connection,
        ApiErrorType.badResponse => CompleteProfileErrorType.badResponse,
        _ => CompleteProfileErrorType.unknown,
      };
}
