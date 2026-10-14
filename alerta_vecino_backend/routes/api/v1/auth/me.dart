import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';

/// Devuelve la información del usuario autenticado.
///
/// Lee el `sub` (userId) del payload JWT inyectado por el middleware y consulta
/// la tabla `users` para devolver los datos completos del perfil.
Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  try {
    final payload = context.read<Map<String, dynamic>>();
    final userId = payload['sub'] as String?;

    if (userId == null) {
      return Response.json(
        statusCode: HttpStatus.unauthorized,
        body: {'error': 'No autorizado'},
      );
    }

    final pool = context.read<Pool<dynamic>>();

    final result = await pool.execute(
      Sql.named(
        'SELECT id, email, first_name, last_name, phone, residency, house, '
        'status, created_at '
        'FROM users WHERE id = @id LIMIT 1',
      ),
      parameters: {'id': TypedValue(Type.uuid, userId)},
    );

    if (result.isEmpty) {
      return Response.json(
        statusCode: HttpStatus.notFound,
        body: {'error': 'Usuario no encontrado'},
      );
    }

    final user = result.first.toColumnMap();

    return Response.json(
      body: {
        'user': {
          'id': user['id'].toString(),
          'email': user['email'] as String?,
          'firstName': user['first_name'] as String?,
          'lastName': user['last_name'] as String?,
          'phone': user['phone'] as String?,
          'residency': user['residency'] as String?,
          'house': user['house'] as String?,
          'status': user['status'] as String?,
          'createdAt': (user['created_at'] as DateTime?)?.toIso8601String(),
        },
      },
    );
  } catch (_) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': 'Error interno del servidor'},
    );
  }
}
