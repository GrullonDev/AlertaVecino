/// Tipos de error que puede producir el flujo de completar perfil.
enum CompleteProfileErrorType {
  /// Datos inválidos enviados al servidor (HTTP 400/422).
  validation,

  /// El token de sesión es inválido o expiró (HTTP 401).
  unauthorized,

  /// El usuario indicado no existe (HTTP 404).
  notFound,

  /// Error interno del servidor (HTTP 5xx).
  server,

  /// El servidor no respondió dentro del tiempo esperado.
  timeout,

  /// No se pudo establecer conexión con el servidor.
  connection,

  /// La respuesta del servidor no pudo interpretarse como JSON válido.
  badResponse,

  /// Cualquier otro error no clasificado.
  unknown,
}

/// Excepción de dominio lanzada por la capa de datos al completar el perfil.
class CompleteProfileException implements Exception {
  const CompleteProfileException(
    this.type, {
    this.statusCode,
    this.serverMessage,
  });

  final CompleteProfileErrorType type;
  final int? statusCode;
  final String? serverMessage;

  @override
  String toString() =>
      'CompleteProfileException(type: $type, statusCode: $statusCode, '
      'serverMessage: $serverMessage)';
}
