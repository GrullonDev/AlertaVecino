import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';

/// Rechaza la solicitud de registro de un usuario.
///
/// `POST /api/admin/users/reject` con cuerpo
/// `{ "id": "<uuid>", "reason": "..." }` marca al usuario como `rejected` y lo
/// desactiva. El `reason` es opcional. Requiere la cabecera `x-admin-key`.
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

  final reason = (body['reason'] as String?)?.trim();
  final pool = context.read<Pool<dynamic>>();

  try {
    final result = await pool.execute(
      Sql.named(
        'UPDATE users '
        'SET status = @status, is_active = FALSE, rejection_reason = @reason, '
        'verified_at = NOW() '
        'WHERE id = @id '
        'RETURNING id, email, status, rejection_reason',
      ),
      parameters: {
        'id': TypedValue(Type.uuid, id),
        'status': TypedValue(Type.text, 'rejected'),
        'reason': reason == null || reason.isEmpty
            ? null
            : TypedValue(Type.text, reason),
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
        'message': 'Usuario rechazado',
        'user': {
          'id': user['id'].toString(),
          'email': user['email'],
          'status': user['status'],
          'reason': user['rejection_reason'],
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
