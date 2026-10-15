import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class PanicService {
  PanicService({http.Client? client, required String token})
      : _client = client ?? http.Client(),
        _token = token;

  final http.Client _client;
  final String _token;

  String get _baseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'http://localhost:8080/api';

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      };

  Future<TriggerResult> trigger({
    required double latitude,
    required double longitude,
    required String emergencyType,
    String? description,
  }) async {
    final url = Uri.parse('$_baseUrl/v1/panic/trigger');
    try {
      final response = await _client
          .post(
            url,
            headers: _headers,
            body: jsonEncode({
              'latitude': latitude,
              'longitude': longitude,
              'emergency_type': emergencyType,
              if (description != null) 'description': description,
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final alert = json['alert'] as Map<String, dynamic>;
        return TriggerResult(
          alertId: alert['id'] as String,
          status: alert['status'] as String,
        );
      }
      return TriggerResult(
        error: 'Server error: ${response.statusCode}',
      );
    } on TimeoutException {
      return TriggerResult(error: 'timeout');
    } on SocketException {
      return TriggerResult(error: 'connection');
    } catch (_) {
      return TriggerResult(error: 'unknown');
    }
  }

  Future<String?> fetchStatus(String alertId) async {
    final url = Uri.parse('$_baseUrl/v1/panic/$alertId/status');
    try {
      final response = await _client
          .get(url, headers: _headers)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return json['status'] as String?;
      }
    } catch (_) {}
    return null;
  }
}

class TriggerResult {
  final String? alertId;
  final String? status;
  final String? error;

  const TriggerResult({this.alertId, this.status, this.error});

  bool get isSuccess => alertId != null && error == null;
}
