// Middleware del árbol de rutas `/api/*`.
import 'package:alerta_vecino_backend/database/database.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';

/// Middleware aplicado a todas las rutas bajo `/api`.
///
/// Publica el pool de conexiones a PostgreSQL en el [RequestContext] para que
/// cada endpoint hijo lo consuma con `context.read<Pool<dynamic>>()` sin abrir
/// conexiones manualmente. Registrar aquí la dependencia mantiene la
/// responsabilidad de infraestructura fuera de la lógica de los endpoints.
Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(provider<Pool<dynamic>>((_) => Database.instance));
}
