import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  try {
    final pool = context.read<Pool<dynamic>>();

    final result = await pool.execute(
      Sql.named(
        'SELECT id, status, created_at, resolved_at '
        'FROM panic_alerts WHERE id = @id',
      ),
      parameters: {
        'id': TypedValue(Type.uuid, id.trim()),
      },
    );

    if (result.isEmpty) {
      return Response.json(
        statusCode: HttpStatus.notFound,
        body: {'error': 'Alerta no encontrada'},
      );
    }

    final row = result.first.toColumnMap();

    return Response.json(
      body: {
        'id': row['id'].toString(),
        'status': row['status'],
        'createdAt': (row['created_at'] as DateTime).toIso8601String(),
        'resolvedAt': row['resolved_at'] != null
            ? (row['resolved_at'] as DateTime).toIso8601String()
            : null,
      },
    );
  } catch (_) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Identificador de alerta inválido'},
    );
  }
}
