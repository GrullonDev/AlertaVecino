/// Tipos de error que puede producir el flujo de registro.
enum RegisterErrorType {
  /// Datos inválidos enviados al servidor (HTTP 400/422).
  validation,

  /// El correo ya está registrado (HTTP 409).
  conflict,

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

/// Excepción de dominio lanzada por la capa de datos cuando falla el registro.
class RegisterException implements Exception {
  const RegisterException(this.type, {this.statusCode, this.serverMessage});

  /// Categoría del error producido.
  final RegisterErrorType type;

  /// Código HTTP devuelto por el servidor, si aplica.
  final int? statusCode;

  /// Mensaje de error devuelto por el servidor, si aplica.
  final String? serverMessage;

  @override
  String toString() =>
      'RegisterException(type: $type, statusCode: $statusCode, '
      'serverMessage: $serverMessage)';
}
