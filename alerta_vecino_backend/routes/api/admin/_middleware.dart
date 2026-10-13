// Middleware del árbol de rutas `/api/admin/*`.
import 'dart:io';

import 'package:alerta_vecino_backend/config/env.dart';
import 'package:dart_frog/dart_frog.dart';

/// Protege las rutas de administración con una llave compartida.
///
/// El cliente debe enviar la cabecera `x-admin-key` con el valor de la variable
/// de entorno `ADMIN_API_KEY`. Sin ella (o si no coincide) responde `401`.
Handler middleware(Handler handler) => handler.use(_adminGuard());

Middleware _adminGuard() {
  return (handler) {
    return (context) async {
      final provided = context.request.headers['x-admin-key'];
      if (provided == null || provided != Env.adminApiKey) {
        return Response.json(
          statusCode: HttpStatus.unauthorized,
          body: {'error': 'No autorizado'},
        );
      }
      return handler(context);
    };
  };
}
