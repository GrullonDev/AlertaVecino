import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';

/// Elimina un usuario de la base de datos.
///
/// `DELETE /api/admin/users/delete?id=<uuid>`
/// Requiere la cabecera `x-admin-key`.
Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.delete) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final id = context.request.uri.queryParameters['id']?.trim();

  if (id == null || id.isEmpty) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Falta el parámetro id'},
    );
  }

  final pool = context.read<Pool<dynamic>>();

  try {
    final result = await pool.execute(
      Sql.named(
        'DELETE FROM users WHERE id = @id '
        'RETURNING id, email',
      ),
      parameters: {'id': TypedValue(Type.uuid, id)},
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
        'message': 'Usuario eliminado',
        'user': {
          'id': user['id'].toString(),
          'email': user['email'],
        },
      },
    );
  } catch (_) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Identificador de usuario inválido'},
    );
  }
}
