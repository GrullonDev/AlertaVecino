import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:neighbour_alert/features/auth/complete_profile/model/complete_profile_error.dart';

abstract class CompleteProfileDataSource {
  /// Envía la residencia y unidad elegidas para completar el perfil.
  ///
  /// [token] viaja en la cabecera `Authorization` y [userId] en el cuerpo, para
  /// que el backend verifique que el usuario autenticado solo modifique su
  /// propio perfil.
  Future<void> completeProfile({
    required String token,
    required String userId,
    required String residency,
    required String house,
  });
}

class CompleteProfileDataSourceImpl implements CompleteProfileDataSource {
  CompleteProfileDataSourceImpl({http.Client? client, Duration? timeout})
    : _client = client ?? http.Client(),
      _timeout = timeout ?? const Duration(seconds: 15);

  final http.Client _client;
  final Duration _timeout;

  String get baseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'http://localhost:8080/api';

  @override
  Future<void> completeProfile({
    required String token,
    required String userId,
    required String residency,
    required String house,
  }) async {
    final url = Uri.parse('$baseUrl/auth/complete-profile');
    final payload = <String, dynamic>{
      'id': userId,
      'residency': residency,
      'house': house,
    };
    dev.log('Request complete-profile: $userId -> $url');

    final http.Response response;
    try {
      response = await _client
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(payload),
          )
          .timeout(_timeout);
    } on TimeoutException {
      dev.log('Complete-profile error: tiempo de espera agotado ($_timeout)');
      throw const CompleteProfileException(CompleteProfileErrorType.timeout);
    } on SocketException catch (e) {
      dev.log('Complete-profile error: no se pudo conectar ($e)');
      throw const CompleteProfileException(CompleteProfileErrorType.connection);
    } on http.ClientException catch (e) {
      dev.log('Complete-profile error: fallo de conexión ($e)');
      throw const CompleteProfileException(CompleteProfileErrorType.connection);
    }

    dev.log('Complete-profile response ${response.statusCode}: ${response.body}');
    _handleResponse(response);
  }

  void _handleResponse(http.Response response) {
    final status = response.statusCode;
    if (status >= 200 && status < 300) return;

    final serverMessage = _decodeBody(response.body)['error'] as String?;

    if (status == 400 || status == 422) {
      throw CompleteProfileException(
        CompleteProfileErrorType.validation,
        statusCode: status,
        serverMessage: serverMessage,
      );
    }
    if (status == 401) {
      throw CompleteProfileException(
        CompleteProfileErrorType.unauthorized,
        statusCode: status,
        serverMessage: serverMessage,
      );
    }
    if (status == 404) {
      throw CompleteProfileException(
        CompleteProfileErrorType.notFound,
        statusCode: status,
        serverMessage: serverMessage,
      );
    }
    if (status >= 500) {
      throw CompleteProfileException(
        CompleteProfileErrorType.server,
        statusCode: status,
        serverMessage: serverMessage,
      );
    }

    throw CompleteProfileException(
      CompleteProfileErrorType.unknown,
      statusCode: status,
      serverMessage: serverMessage,
    );
  }

  Map<String, dynamic> _decodeBody(String body) {
    if (body.trim().isEmpty) return const {};
    try {
      final decoded = jsonDecode(body);
      return decoded is Map<String, dynamic> ? decoded : const {};
    } on FormatException {
      throw const CompleteProfileException(
        CompleteProfileErrorType.badResponse,
      );
    }
  }
}
