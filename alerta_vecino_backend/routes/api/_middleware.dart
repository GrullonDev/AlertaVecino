// Middleware del árbol de rutas `/api/*`.
import 'package:alerta_vecino_backend/auth/jwt_middleware.dart';
import 'package:alerta_vecino_backend/database/database.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(jwtGuard())
      .use(provider<Pool<dynamic>>((_) => Database.instance));
}
