import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:neighbour_alert/core/api/api_exception.dart';
import 'package:neighbour_alert/core/session/session_service.dart';

class ApiClient {
  ApiClient({
    required SessionService session,
    http.Client? client,
    Duration? timeout,
  })  : _session = session,
        _client = client ?? http.Client(),
        _timeout = timeout ?? const Duration(seconds: 15);

  final SessionService _session;
  final http.Client _client;
  final Duration _timeout;

  String get baseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'http://localhost:8080/api';

  Map<String, String> get _authHeaders => {
        'Content-Type': 'application/json',
        if (_session.token != null)
          'Authorization': 'Bearer ${_session.token}',
      };

  Future<Map<String, dynamic>> get(String path) async {
    final url = Uri.parse('$baseUrl$path');
    dev.log('[api] GET $url');

    final response = await _send(() => _client.get(url, headers: _authHeaders));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final url = Uri.parse('$baseUrl$path');
    dev.log('[api] POST $url');

    final response = await _send(
      () => _client.post(
        url,
        headers: _authHeaders,
        body: body != null ? jsonEncode(body) : null,
      ),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> patch(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final url = Uri.parse('$baseUrl$path');
    dev.log('[api] PATCH $url');

    final response = await _send(
      () => _client.patch(
        url,
        headers: _authHeaders,
        body: body != null ? jsonEncode(body) : null,
      ),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> delete(String path) async {
    final url = Uri.parse('$baseUrl$path');
    dev.log('[api] DELETE $url');

    final response =
        await _send(() => _client.delete(url, headers: _authHeaders));
    return _handleResponse(response);
  }

  Future<http.Response> _send(
    Future<http.Response> Function() request,
  ) async {
    try {
      return await request().timeout(_timeout);
    } on TimeoutException {
      throw const ApiException(ApiErrorType.timeout);
    } on SocketException {
      throw const ApiException(ApiErrorType.connection);
    } on http.ClientException {
      throw const ApiException(ApiErrorType.connection);
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    dev.log('[api] ${response.statusCode}: ${response.body}');
    final json = _decodeBody(response.body);
    final status = response.statusCode;

    if (status >= 200 && status < 300) return json;

    final serverMessage = json['error'] as String?;

    throw ApiException(
      _errorTypeFromStatus(status),
      statusCode: status,
      serverMessage: serverMessage,
    );
  }

  static ApiErrorType _errorTypeFromStatus(int status) {
    return switch (status) {
      400 || 422 => ApiErrorType.validation,
      401 => ApiErrorType.unauthorized,
      403 => ApiErrorType.forbidden,
      404 => ApiErrorType.notFound,
      409 => ApiErrorType.conflict,
      >= 500 => ApiErrorType.server,
      _ => ApiErrorType.unknown,
    };
  }

  Map<String, dynamic> _decodeBody(String body) {
    if (body.trim().isEmpty) return const {};
    try {
      final decoded = jsonDecode(body);
      return decoded is Map<String, dynamic> ? decoded : const {};
    } on FormatException {
      throw const ApiException(ApiErrorType.badResponse);
    }
  }
}
