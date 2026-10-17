enum AnnouncementsErrorType {
  server,
  timeout,
  connection,
  badResponse,
  unauthorized,
  unknown,
}

class AnnouncementsException implements Exception {
  const AnnouncementsException(this.type, {this.statusCode, this.serverMessage});

  final AnnouncementsErrorType type;
  final int? statusCode;
  final String? serverMessage;

  @override
  String toString() =>
      'AnnouncementsException(type: $type, statusCode: $statusCode, '
      'serverMessage: $serverMessage)';
}
