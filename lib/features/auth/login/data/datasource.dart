import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:neighbour_alert/features/auth/login/model/login_request.dart';
import 'package:neighbour_alert/features/auth/login/model/login_response.dart';

abstract class DataSource {
  Future<LoginResponse> login(LoginRequest request);
}

class DataSourceImpl implements DataSource {
  final String baseUrl =
      dotenv.env['API_BASE_URL'] ?? 'http://localhost:8080/api';

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      dev.log('Request: ${request.toJson()}');
      final url = Uri.parse('$baseUrl/auth/login');

      final result = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      dev.log('Response: $result');
      final data = jsonDecode(result.body) as Map<String, dynamic>;
      return LoginResponse.fromJson(data);
    } catch (e) {
      dev.log('Hubo un error $e');
      return LoginResponse.fromJson({});
    }
  }
}
