import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';

/// Rechaza la solicitud de registro de un usuario.
///
/// `POST /api/admin/users/:id/reject` marca al usuario como `rejected` y lo
/// desactiva. Acepta opcionalmente un cuerpo JSON `{ "reason": "..." }` que se
/// guarda en `rejection_reason`. Requiere la cabecera `x-admin-key`.
Future<Response> onRequest(RequestContext context, String id) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  String? reason;
  try {
    final body = await context.request.json();
    if (body is Map<String, dynamic>) {
      reason = (body['reason'] as String?)?.trim();
    }
  } catch (_) {
    // El cuerpo es opcional: si no es JSON válido se rechaza sin motivo.
  }

  final pool = context.read<Pool<dynamic>>();

  try {
    final result = await pool.execute(
      Sql.named(
        "UPDATE users SET status = 'rejected', is_active = FALSE, "
        'rejection_reason = @reason, verified_at = NOW() '
        'WHERE id = @id '
        'RETURNING id, email, status, rejection_reason',
      ),
      parameters: {
        'id': TypedValue(Type.uuid, id),
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
