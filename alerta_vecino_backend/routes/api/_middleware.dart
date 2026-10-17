// Middleware del árbol de rutas `/api/*`.
import 'dart:io';

import 'package:alerta_vecino_backend/auth/jwt_middleware.dart';
import 'package:alerta_vecino_backend/database/database.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(_cors())
      .use(jwtGuard())
      .use(provider<Pool<dynamic>>((_) => Database.instance));
}

Middleware _cors() {
  return (handler) {
    return (context) async {
      if (context.request.method == HttpMethod.options) {
        return Response(
          statusCode: HttpStatus.noContent,
          headers: _corsHeaders,
        );
      }

      final response = await handler(context);
      return response.copyWith(
        headers: {...response.headers, ..._corsHeaders},
      );
    };
  };
}

const _corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, PATCH, DELETE, OPTIONS',
  'Access-Control-Allow-Headers':
      'Content-Type, Authorization, x-admin-key',
};
