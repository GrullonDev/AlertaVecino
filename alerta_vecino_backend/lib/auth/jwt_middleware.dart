import 'dart:io';

import 'package:alerta_vecino_backend/auth/jwt_service.dart';
import 'package:dart_frog/dart_frog.dart';

/// Middleware que protege rutas con JWT.
///
/// Extrae el token de la cabecera `Authorization: Bearer <token>`, lo verifica
/// y coloca el payload decodificado en el [RequestContext] como
/// `Map<String, dynamic>` bajo la clave `jwtPayload`.
///
/// Las rutas bajo `/api/auth/` quedan excluidas para permitir el login y
/// registro sin token.
Middleware jwtGuard() {
  return (handler) {
    return (context) async {
      final path = context.request.uri.path;
      // ignore: avoid_print
      print('[jwtGuard] path=$path');

      if (_isPublicRoute(path)) {
        return handler(context);
      }

      final header =
          context.request.headers['authorization'] ??
          context.request.headers['Authorization'];
      final token = _extractBearer(header);

      if (token == null) {
        return Response.json(
          statusCode: HttpStatus.unauthorized,
          body: {'error': 'Token de autenticación requerido'},
        );
      }

      final payload = JwtService.verifySessionToken(token);
      if (payload == null) {
        return Response.json(
          statusCode: HttpStatus.unauthorized,
          body: {'error': 'Token inválido o expirado'},
        );
      }

      final updatedHandler = handler.use(
        provider<Map<String, dynamic>>((_) => payload),
      );

      return updatedHandler(context);
    };
  };
}

bool _isPublicRoute(String path) {
  const publicPrefixes = [
    '/auth/login',
    '/auth/register',
    '/auth/pending_approval',
    '/api/auth/login',
    '/api/auth/register',
    '/api/auth/pending_approval',
    '/admin/',
    '/api/admin/',
  ];
  return publicPrefixes.any(path.startsWith);
}

String? _extractBearer(String? header) {
  if (header == null) return null;
  const prefix = 'Bearer ';
  if (!header.startsWith(prefix)) return null;
  final token = header.substring(prefix.length).trim();
  return token.isEmpty ? null : token;
}
