// Middleware del árbol de rutas `/api/admin/*`.
import 'dart:io';

import 'package:alerta_vecino_backend/auth/jwt_service.dart';
import 'package:alerta_vecino_backend/config/env.dart';
import 'package:dart_frog/dart_frog.dart';

/// Protege las rutas de administración.
///
/// Acepta dos formas de autenticación:
///   1. Cabecera `x-admin-key` con la llave compartida.
///   2. JWT de un usuario con `role = admin`.
Handler middleware(Handler handler) => handler.use(_adminGuard());

Middleware _adminGuard() {
  return (handler) {
    return (context) async {
      final adminKey = context.request.headers['x-admin-key'];
      if (adminKey != null && adminKey == Env.adminApiKey) {
        return handler(context);
      }

      final authHeader =
          context.request.headers['authorization'] ??
          context.request.headers['Authorization'];
      final token = _extractBearer(authHeader);

      if (token != null) {
        final payload = JwtService.verifySessionToken(token);
        if (payload != null) {
          final email = payload['email'] as String? ?? '';
          final role = _resolveRole(email, payload);
          if (role == 'admin') {
            return handler(context);
          }
        }
      }

      return Response.json(
        statusCode: HttpStatus.unauthorized,
        body: {'error': 'No autorizado'},
      );
    };
  };
}

String _resolveRole(
  String email,
  Map<String, dynamic> payload,
) {
  if (payload.containsKey('role')) {
    return payload['role'] as String? ?? 'resident';
  }
  return 'resident';
}

String? _extractBearer(String? header) {
  if (header == null) return null;
  const prefix = 'Bearer ';
  if (!header.startsWith(prefix)) return null;
  final token = header.substring(prefix.length).trim();
  return token.isEmpty ? null : token;
}
