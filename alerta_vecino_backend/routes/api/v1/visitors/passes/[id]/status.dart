import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';

/// Actualiza el estado de un pase de visita.
///
/// `PATCH /api/v1/visitors/passes/<id>/status`
/// Body: `{ "status": "at_gate|entered|expired" }`
/// Requiere JWT. Para los estados `at_gate` y `entered` solo usuarios
/// con rol `admin` o `guard`.
Future<Response> onRequest(
  RequestContext context,
  String id,
) async {
  if (context.request.method != HttpMethod.patch) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  try {
    final payload = context.read<Map<String, dynamic>>();
    final role = payload['role'] as String? ?? 'resident';

    final body =
        await context.request.json() as Map<String, dynamic>;
    final newStatus = (body['status'] as String?)?.trim();

    const validStatuses = [
      'expected',
      'at_gate',
      'entered',
      'expired',
    ];

    if (newStatus == null || !validStatuses.contains(newStatus)) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {
          'error': 'status inválido. '
              'Valores: ${validStatuses.join(", ")}',
        },
      );
    }

    if ((newStatus == 'at_gate' || newStatus == 'entered') &&
        role != 'admin' &&
        role != 'guard') {
      return Response.json(
        statusCode: HttpStatus.forbidden,
        body: {
          'error':
              'Solo administradores o guardias pueden '
              'registrar la entrada',
        },
      );
    }

    final passId = id.trim();
    final pool = context.read<Pool<dynamic>>();

    final entryClause = newStatus == 'entered'
        ? ', entry_time = NOW()'
        : '';

    final result = await pool.execute(
      Sql.named(
        'UPDATE visitor_passes '
        'SET status = @status$entryClause '
        'WHERE id = @id '
        'RETURNING id, status, entry_time',
      ),
      parameters: {
        'id': TypedValue(Type.uuid, passId),
        'status': TypedValue(Type.text, newStatus),
      },
    );

    if (result.isEmpty) {
      return Response.json(
        statusCode: HttpStatus.notFound,
        body: {'error': 'Pase no encontrado'},
      );
    }

    final row = result.first.toColumnMap();

    return Response.json(
      body: {
        'message': 'Estado actualizado',
        'pass': {
          'id': row['id'].toString(),
          'status': row['status'],
          'entryTime': (row['entry_time'] as DateTime?)
              ?.toIso8601String(),
        },
      },
    );
  } on FormatException {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Formato JSON inválido'},
    );
  } catch (_) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Identificador de pase inválido'},
    );
  }
}
