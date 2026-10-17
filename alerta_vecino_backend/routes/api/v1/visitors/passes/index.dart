import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';

/// Pases de visita del residente autenticado.
///
/// `GET  /api/v1/visitors/passes` — lista los pases del residente.
/// `POST /api/v1/visitors/passes` — crea un nuevo pase.
Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => _list(context),
    HttpMethod.post => _create(context),
    _ => Future.value(
      Response(statusCode: HttpStatus.methodNotAllowed),
    ),
  };
}

Future<Response> _list(RequestContext context) async {
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
        'SELECT id, visitor_name, dpi, plate, visit_type, '
        'valid_from, valid_until, status, entry_time, '
        'created_at '
        'FROM visitor_passes '
        'WHERE resident_id = @resident_id '
        'ORDER BY created_at DESC',
      ),
      parameters: {
        'resident_id': TypedValue(Type.uuid, userId),
      },
    );

    return Response.json(
      body: {
        'count': result.length,
        'passes': [
          for (final row in result)
            _passJson(row.toColumnMap()),
        ],
      },
    );
  } catch (_) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': 'Error interno del servidor'},
    );
  }
}

Future<Response> _create(RequestContext context) async {
  try {
    final payload = context.read<Map<String, dynamic>>();
    final userId = payload['sub'] as String?;

    if (userId == null) {
      return Response.json(
        statusCode: HttpStatus.unauthorized,
        body: {'error': 'No autorizado'},
      );
    }

    final body =
        await context.request.json() as Map<String, dynamic>;

    final visitorName =
        (body['visitor_name'] as String?)?.trim();
    final dpi = (body['dpi'] as String?)?.trim();
    final plate = (body['plate'] as String?)?.trim();
    final visitType =
        (body['visit_type'] as String?)?.trim() ?? 'other';
    final validFromStr = body['valid_from'] as String?;
    final validUntilStr = body['valid_until'] as String?;

    if (visitorName == null || visitorName.isEmpty) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {'error': 'Falta el nombre del visitante'},
      );
    }

    if (validFromStr == null || validUntilStr == null) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {
          'error': 'Faltan las fechas valid_from y valid_until',
        },
      );
    }

    final validFrom = DateTime.tryParse(validFromStr);
    final validUntil = DateTime.tryParse(validUntilStr);

    if (validFrom == null || validUntil == null) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {'error': 'Formato de fecha inválido (ISO 8601)'},
      );
    }

    const validTypes = [
      'family',
      'delivery',
      'service',
      'other',
    ];
    if (!validTypes.contains(visitType)) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {
          'error': 'visit_type inválido. '
              'Valores: ${validTypes.join(", ")}',
        },
      );
    }

    final pool = context.read<Pool<dynamic>>();
    final result = await pool.execute(
      Sql.named(
        'INSERT INTO visitor_passes '
        '(resident_id, visitor_name, dpi, plate, '
        'visit_type, valid_from, valid_until) '
        'VALUES (@resident_id, @name, @dpi, @plate, '
        '@visit_type, @valid_from, @valid_until) '
        'RETURNING id, created_at',
      ),
      parameters: {
        'resident_id': TypedValue(Type.uuid, userId),
        'name': TypedValue(Type.text, visitorName),
        'dpi': _textOrNull(dpi),
        'plate': _textOrNull(plate),
        'visit_type': TypedValue(Type.text, visitType),
        'valid_from': TypedValue(
          Type.timestampWithTimezone,
          validFrom,
        ),
        'valid_until': TypedValue(
          Type.timestampWithTimezone,
          validUntil,
        ),
      },
    );

    final row = result.first.toColumnMap();

    return Response.json(
      statusCode: HttpStatus.created,
      body: {
        'message': 'Pase creado',
        'pass': {
          'id': row['id'].toString(),
          'createdAt': (row['created_at'] as DateTime)
              .toIso8601String(),
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
      statusCode: HttpStatus.internalServerError,
      body: {'error': 'Error interno del servidor'},
    );
  }
}

Map<String, dynamic> _passJson(Map<String, dynamic> row) => {
  'id': row['id'].toString(),
  'visitorName': row['visitor_name'],
  'dpi': row['dpi'],
  'plate': row['plate'],
  'visitType': row['visit_type'],
  'validFrom':
      (row['valid_from'] as DateTime).toIso8601String(),
  'validUntil':
      (row['valid_until'] as DateTime).toIso8601String(),
  'status': row['status'],
  'entryTime': (row['entry_time'] as DateTime?)
      ?.toIso8601String(),
  'createdAt':
      (row['created_at'] as DateTime).toIso8601String(),
};

TypedValue? _textOrNull(String? value) =>
    (value == null || value.isEmpty)
        ? null
        : TypedValue(Type.text, value);
