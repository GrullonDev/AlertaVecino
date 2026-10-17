import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';

/// Detalle de un pase de visita.
///
/// `GET /api/v1/visitors/passes/<id>`
/// Requiere JWT. Devuelve los datos del pase incluyendo información
/// del residente que lo creó (nombre, residencia, unidad).
Future<Response> onRequest(
  RequestContext context,
  String id,
) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final passId = id.trim();
  if (passId.isEmpty) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Falta el id del pase'},
    );
  }

  try {
    final pool = context.read<Pool<dynamic>>();

    final result = await pool.execute(
      Sql.named(
        'SELECT vp.id, vp.visitor_name, vp.dpi, vp.plate, '
        'vp.visit_type, vp.valid_from, vp.valid_until, '
        'vp.status, vp.entry_time, vp.created_at, '
        'u.id AS resident_id, u.first_name, u.last_name, '
        'u.email, u.residency, u.house '
        'FROM visitor_passes vp '
        'JOIN users u ON u.id = vp.resident_id '
        'WHERE vp.id = @id LIMIT 1',
      ),
      parameters: {'id': TypedValue(Type.uuid, passId)},
    );

    if (result.isEmpty) {
      return Response.json(
        statusCode: HttpStatus.notFound,
        body: {'error': 'Pase no encontrado'},
      );
    }

    final row = result.first.toColumnMap();
    final firstName = row['first_name'] as String? ?? '';
    final lastName = row['last_name'] as String? ?? '';
    final residentName = '$firstName $lastName'.trim();

    return Response.json(
      body: {
        'pass': {
          'id': row['id'].toString(),
          'visitorName': row['visitor_name'],
          'dpi': row['dpi'],
          'plate': row['plate'],
          'visitType': row['visit_type'],
          'validFrom': (row['valid_from'] as DateTime)
              .toIso8601String(),
          'validUntil': (row['valid_until'] as DateTime)
              .toIso8601String(),
          'status': row['status'],
          'entryTime': (row['entry_time'] as DateTime?)
              ?.toIso8601String(),
          'createdAt': (row['created_at'] as DateTime)
              .toIso8601String(),
          'resident': {
            'id': row['resident_id'].toString(),
            'name': residentName,
            'email': row['email'],
            'residency': row['residency'],
            'house': row['house'],
          },
        },
      },
    );
  } catch (_) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Identificador de pase inválido'},
    );
  }
}
