import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';

/// Resuelve una alerta de pánico.
///
/// `PATCH /api/panic/<id>/resolve`
/// Requiere JWT. Marca la alerta como `resolved`, registra quién la atendió
/// y la fecha de resolución.
Future<Response> onRequest(
  RequestContext context,
  String id,
) async {
  if (context.request.method != HttpMethod.patch) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  try {
    final payload = context.read<Map<String, dynamic>>();
    final resolvedBy = payload['sub'] as String?;

    if (resolvedBy == null) {
      return Response.json(
        statusCode: HttpStatus.unauthorized,
        body: {'error': 'No autorizado'},
      );
    }

    final alertId = id.trim();
    if (alertId.isEmpty) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {'error': 'Falta el id de la alerta'},
      );
    }

    final pool = context.read<Pool<dynamic>>();

    final result = await pool.execute(
      Sql.named(
        'UPDATE panic_alerts '
        'SET status = @status, resolved_by = @resolved_by, '
        'resolved_at = NOW() '
        'WHERE id = @id AND status = @active_status '
        'RETURNING id, status, resolved_at',
      ),
      parameters: {
        'id': TypedValue(Type.uuid, alertId),
        'status': TypedValue(Type.text, 'resolved'),
        'active_status': TypedValue(Type.text, 'active'),
        'resolved_by': TypedValue(Type.uuid, resolvedBy),
      },
    );

    if (result.isEmpty) {
      return Response.json(
        statusCode: HttpStatus.notFound,
        body: {
          'error': 'Alerta no encontrada o ya resuelta',
        },
      );
    }

    final row = result.first.toColumnMap();

    return Response.json(
      body: {
        'message': 'Alerta resuelta',
        'alert': {
          'id': row['id'].toString(),
          'status': row['status'],
          'resolvedAt':
              (row['resolved_at'] as DateTime).toIso8601String(),
        },
      },
    );
  } catch (_) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Identificador de alerta inválido'},
    );
  }
}
