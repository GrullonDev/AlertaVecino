/// Tipos de error que puede producir el flujo de inicio de sesión.
enum LoginErrorType {
  /// Credenciales incorrectas (HTTP 401/403 o usuario no encontrado).
  invalidCredentials,

  /// Datos inválidos enviados al servidor (HTTP 400/422).
  validation,

  /// Conflicto, por ejemplo un correo ya registrado (HTTP 409).
  conflict,

  /// El recurso solicitado no existe (HTTP 404).
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

/// Excepción de dominio lanzada por la capa de datos cuando falla el login.
///
/// Permite a la capa de presentación reaccionar de forma específica a cada
/// tipo de fallo (credenciales, red, timeout, servidor, etc.).
class LoginException implements Exception {
  const LoginException(this.type, {this.statusCode, this.serverMessage});

  /// Categoría del error producido.
  final LoginErrorType type;

  /// Código HTTP devuelto por el servidor, si aplica.
  final int? statusCode;

  /// Mensaje de error devuelto por el servidor, si aplica.
  final String? serverMessage;

  @override
  String toString() =>
      'LoginException(type: $type, statusCode: $statusCode, '
      'serverMessage: $serverMessage)';
}
