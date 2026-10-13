// Acceso centralizado a las variables de entorno del backend.
import 'package:dotenv/dotenv.dart';

/// Punto único de lectura de las variables de entorno.
///
/// Carga el archivo `.env` (relativo al directorio de ejecución) y expone
/// además las variables del sistema operativo, de modo que en producción los
/// valores puedan inyectarse sin depender de un archivo.
class Env {
  Env._();

  static final DotEnv _env = DotEnv(includePlatformEnvironment: true)..load();

  /// Host de PostgreSQL (`DB_HOST`).
  static String get dbHost => _env.getOrElse('DB_HOST', () => 'localhost');

  /// Puerto de PostgreSQL (`DB_PORT`).
  static int get dbPort => int.parse(_env.getOrElse('DB_PORT', () => '5432'));

  /// Nombre de la base de datos (`DB_NAME`).
  static String get dbName =>
      _env.getOrElse('DB_NAME', () => 'alerta_vecino_db');

  /// Usuario de PostgreSQL (`DB_USER`).
  static String get dbUser => _env.getOrElse('DB_USER', () => 'alerta_vecino');

  /// Contraseña de PostgreSQL (`DB_PASSWORD`). Nunca debe registrarse en logs.
  static String get dbPassword => _env.getOrElse('DB_PASSWORD', () => '');

  /// Llave secreta para firmar los JWT (`JWT_SECRET`).
  ///
  /// Lanza un [StateError] si no está definida, para evitar emitir tokens
  /// firmados con una llave vacía.
  static String get jwtSecret {
    final secret = _env.getOrElse('JWT_SECRET', () => '');
    if (secret.isEmpty) {
      throw StateError('Falta la variable de entorno JWT_SECRET');
    }
    return secret;
  }

  /// Llave compartida para las rutas de administración (`ADMIN_API_KEY`).
  ///
  /// Se envía en la cabecera `x-admin-key`. Lanza un [StateError] si no está
  /// definida, para evitar dejar el panel de administración sin protección.
  static String get adminApiKey {
    final key = _env.getOrElse('ADMIN_API_KEY', () => '');
    if (key.isEmpty) {
      throw StateError('Falta la variable de entorno ADMIN_API_KEY');
    }
    return key;
  }
}
