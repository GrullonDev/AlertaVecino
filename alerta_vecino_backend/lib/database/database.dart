// Conexión compartida a PostgreSQL.
import 'package:alerta_vecino_backend/config/env.dart';
import 'package:postgres/postgres.dart';

/// Fábrica del pool de conexiones a PostgreSQL.
///
/// Se usa un [Pool] en lugar de una única [Connection] porque una conexión
/// de PostgreSQL no soporta operaciones concurrentes: el pool garantiza que
/// cada petición adquiera su propia conexión de forma transparente.
class Database {
  Database._();

  static final Pool<dynamic> _pool = Pool.withEndpoints(
    [
      Endpoint(
        host: Env.dbHost,
        port: Env.dbPort,
        database: Env.dbName,
        username: Env.dbUser,
        password: Env.dbPassword,
      ),
    ],
    settings: const PoolSettings(
      sslMode: SslMode.disable,
      maxConnectionCount: 5,
    ),
  );

  /// Pool compartido para ser provisto a través del `RequestContext`.
  static Pool<dynamic> get instance => _pool;
}
