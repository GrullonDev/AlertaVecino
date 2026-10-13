import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';

/// Aprueba la solicitud de registro de un usuario.
///
/// `POST /api/admin/users/approve` con cuerpo `{ "id": "<uuid>" }` marca al
/// usuario como `approved` y lo activa, permitiéndole iniciar sesión.
/// Requiere la cabecera `x-admin-key`.
Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final Map<String, dynamic> body;
  try {
    final decoded = await context.request.json();
    if (decoded is! Map<String, dynamic>) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {'error': 'El cuerpo de la petición debe ser un objeto JSON'},
      );
    }
    body = decoded;
  } on FormatException {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Formato JSON inválido'},
    );
  }

  final id = (body['id'] as String?)?.trim();
  if (id == null || id.isEmpty) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Falta el id del usuario'},
    );
  }

  final pool = context.read<Pool<dynamic>>();

  try {
    final result = await pool.execute(
      Sql.named(
        'UPDATE users '
        'SET status = @status, is_active = TRUE, rejection_reason = NULL, '
        'verified_at = NOW() '
        'WHERE id = @id '
        'RETURNING id, email, status, verified_at',
      ),
      parameters: {
        'id': TypedValue(Type.uuid, id),
        'status': TypedValue(Type.text, 'approved'),
      },
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
        'message': 'Usuario aprobado correctamente',
        'user': {
          'id': user['id'].toString(),
          'email': user['email'],
          'status': user['status'],
          'verifiedAt': user['verified_at']?.toString(),
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
