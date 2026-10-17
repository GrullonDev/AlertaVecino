import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:neighbour_alert/features/announcements/data/announcements_error.dart';
import 'package:neighbour_alert/features/announcements/models/announcement.dart';

abstract class AnnouncementsDataSource {
  Future<List<Announcement>> list({String? category, required String token});
}

class AnnouncementsDataSourceImpl implements AnnouncementsDataSource {
  AnnouncementsDataSourceImpl({http.Client? client, Duration? timeout})
    : _client = client ?? http.Client(),
      _timeout = timeout ?? const Duration(seconds: 15);

  final http.Client _client;
  final Duration _timeout;

  String get _baseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'http://localhost:8080/api/v1';

  @override
  Future<List<Announcement>> list({
    String? category,
    required String token,
  }) async {
    var url = Uri.parse('$_baseUrl/announcements');
    if (category != null && category.isNotEmpty) {
      url = url.replace(queryParameters: {'category': category});
    }

    dev.log('[announcements] GET $url');

    final http.Response response;
    try {
      response = await _client
          .get(url, headers: _headers(token))
          .timeout(_timeout);
    } on TimeoutException {
      throw const AnnouncementsException(AnnouncementsErrorType.timeout);
    } on SocketException {
      throw const AnnouncementsException(AnnouncementsErrorType.connection);
    } on http.ClientException {
      throw const AnnouncementsException(AnnouncementsErrorType.connection);
    }

    dev.log('[announcements] ${response.statusCode}: ${response.body}');

    if (response.statusCode == 401) {
      throw const AnnouncementsException(AnnouncementsErrorType.unauthorized);
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return _parseList(response.body);
    }

    if (response.statusCode >= 500) {
      throw AnnouncementsException(
        AnnouncementsErrorType.server,
        statusCode: response.statusCode,
      );
    }

    throw AnnouncementsException(
      AnnouncementsErrorType.unknown,
      statusCode: response.statusCode,
    );
  }

  Map<String, String> _headers(String token) => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  List<Announcement> _parseList(String body) {
    try {
      final json = jsonDecode(body) as Map<String, dynamic>;
      final items = json['announcements'] as List<dynamic>? ?? [];
      return items
          .cast<Map<String, dynamic>>()
          .map(Announcement.fromJson)
          .toList();
    } on FormatException {
      throw const AnnouncementsException(AnnouncementsErrorType.badResponse);
    }
  }
}
