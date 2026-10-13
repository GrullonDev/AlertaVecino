import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:neighbour_alert/features/auth/register/model/register_error.dart';
import 'package:neighbour_alert/features/auth/register/model/registration_draft.dart';

abstract class RegisterDataSource {
  /// Envía la solicitud de registro al backend.
  ///
  /// [residency] y [house] completan el perfil del vecino una vez elegida la
  /// residencia.
  Future<void> register(
    RegistrationDraft draft, {
    String? residency,
    String? house,
  });
}

class RegisterDataSourceImpl implements RegisterDataSource {
  RegisterDataSourceImpl({http.Client? client, Duration? timeout})
    : _client = client ?? http.Client(),
      _timeout = timeout ?? const Duration(seconds: 15);

  final http.Client _client;
  final Duration _timeout;

  String get baseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'http://localhost:8080/api';

  @override
  Future<void> register(
    RegistrationDraft draft, {
    String? residency,
    String? house,
  }) async {
    final url = Uri.parse('$baseUrl/auth/register');
    final payload = <String, dynamic>{
      'fullName': draft.fullName,
      'email': draft.email,
      'phone': draft.phone,
      'password': draft.password,
      if (residency != null && residency.isNotEmpty) 'residency': residency,
      if (house != null && house.isNotEmpty) 'house': house,
    };
    dev.log('Request register: ${draft.email} -> $url');

    final http.Response response;
    try {
      response = await _client
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(payload),
          )
          .timeout(_timeout);
    } on TimeoutException {
      dev.log('Register error: tiempo de espera agotado ($_timeout)');
      throw const RegisterException(RegisterErrorType.timeout);
    } on SocketException catch (e) {
      dev.log('Register error: no se pudo conectar ($e)');
      throw const RegisterException(RegisterErrorType.connection);
    } on http.ClientException catch (e) {
      dev.log('Register error: fallo de conexión ($e)');
      throw const RegisterException(RegisterErrorType.connection);
    }

    dev.log('Register response ${response.statusCode}: ${response.body}');
    _handleResponse(response);
  }

  void _handleResponse(http.Response response) {
    final status = response.statusCode;
    if (status >= 200 && status < 300) return;

    final serverMessage = _decodeBody(response.body)['error'] as String?;

    if (status == 400 || status == 422) {
      throw RegisterException(
        RegisterErrorType.validation,
        statusCode: status,
        serverMessage: serverMessage,
      );
    }
    if (status == 409) {
      throw RegisterException(
        RegisterErrorType.conflict,
        statusCode: status,
        serverMessage: serverMessage,
      );
    }
    if (status >= 500) {
      throw RegisterException(
        RegisterErrorType.server,
        statusCode: status,
        serverMessage: serverMessage,
      );
    }

    throw RegisterException(
      RegisterErrorType.unknown,
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
      throw const RegisterException(RegisterErrorType.badResponse);
    }
  }
}
