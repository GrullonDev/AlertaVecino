import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:neighbour_alert/features/auth/login/model/login_error.dart';
import 'package:neighbour_alert/features/auth/login/model/login_request.dart';
import 'package:neighbour_alert/features/auth/login/model/login_response.dart';

abstract class DataSource {
  Future<LoginResponse> login(LoginRequest request);
}

class DataSourceImpl implements DataSource {
  DataSourceImpl({http.Client? client, Duration? timeout})
    : _client = client ?? http.Client(),
      _timeout = timeout ?? const Duration(seconds: 15);

  final http.Client _client;
  final Duration _timeout;

  String get baseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'http://localhost:8080/api';

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    final url = Uri.parse('$baseUrl/auth/login');
    dev.log('Request: ${request.toJson()} -> $url');

    final http.Response response;
    try {
      response = await _client
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(request.toJson()),
          )
          .timeout(_timeout);
    } on TimeoutException {
      dev.log('Login error: tiempo de espera agotado ($_timeout)');
      throw const LoginException(LoginErrorType.timeout);
    } on SocketException catch (e) {
      dev.log('Login error: no se pudo conectar ($e)');
      throw const LoginException(LoginErrorType.connection);
    } on http.ClientException catch (e) {
      dev.log('Login error: fallo de conexión ($e)');
      throw const LoginException(LoginErrorType.connection);
    }

    dev.log('Response ${response.statusCode}: ${response.body}');
    return _handleResponse(response);
  }

  LoginResponse _handleResponse(http.Response response) {
    final json = _decodeBody(response.body);
    final serverMessage = json['error'] as String?;
    final status = response.statusCode;

    if (status >= 200 && status < 300) {
      return LoginResponse.fromJson(json);
    }

    if (status == 400 || status == 422) {
      throw LoginException(
        LoginErrorType.validation,
        statusCode: status,
        serverMessage: serverMessage,
      );
    }
    if (status == 401 || status == 403) {
      throw LoginException(
        LoginErrorType.invalidCredentials,
        statusCode: status,
        serverMessage: serverMessage,
      );
    }
    if (status == 404) {
      throw LoginException(
        LoginErrorType.notFound,
        statusCode: status,
        serverMessage: serverMessage,
      );
    }
    if (status == 409) {
      throw LoginException(
        LoginErrorType.conflict,
        statusCode: status,
        serverMessage: serverMessage,
      );
    }
    if (status >= 500) {
      throw LoginException(
        LoginErrorType.server,
        statusCode: status,
        serverMessage: serverMessage,
      );
    }

    throw LoginException(
      LoginErrorType.unknown,
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
      throw const LoginException(LoginErrorType.badResponse);
    }
  }
}
