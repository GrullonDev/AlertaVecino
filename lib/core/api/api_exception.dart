enum ApiErrorType {
  validation,
  unauthorized,
  forbidden,
  notFound,
  conflict,
  server,
  timeout,
  connection,
  badResponse,
  unknown,
}

class ApiException implements Exception {
  const ApiException(this.type, {this.statusCode, this.serverMessage});

  final ApiErrorType type;
  final int? statusCode;
  final String? serverMessage;

  @override
  String toString() =>
      'ApiException($type, statusCode: $statusCode, '
      'serverMessage: $serverMessage)';
}
