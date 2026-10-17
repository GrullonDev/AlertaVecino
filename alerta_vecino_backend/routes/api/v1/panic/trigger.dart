import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';

/// Emite una alerta de pánico desde un residente autenticado.
///
/// `POST /api/panic/trigger`
/// Body: `{ "latitude", "longitude", "emergency_type", "description"? }`
Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
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

    final body = await context.request.json() as Map<String, dynamic>;

    final latitude = (body['latitude'] as num?)?.toDouble();
    final longitude = (body['longitude'] as num?)?.toDouble();
    final emergencyType = (body['emergency_type'] as String?)?.trim();
    final description = (body['description'] as String?)?.trim();

    if (latitude == null || longitude == null) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {'error': 'Coordenadas (latitude, longitude) requeridas'},
      );
    }

    if (latitude < -90 || latitude > 90 ||
        longitude < -180 || longitude > 180) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {'error': 'Coordenadas fuera de rango válido'},
      );
    }

    const validTypes = [
      'robbery',
      'medical',
      'fire',
      'intrusion',
      'suspicious',
      'other',
    ];

    if (emergencyType == null ||
        emergencyType.isEmpty ||
        !validTypes.contains(emergencyType)) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {
          'error': 'emergency_type inválido. '
              'Valores aceptados: ${validTypes.join(", ")}',
        },
      );
    }

    final pool = context.read<Pool<dynamic>>();

    final result = await pool.execute(
      Sql.named(
        'INSERT INTO panic_alerts '
        '(user_id, latitude, longitude, emergency_type, description, status) '
        'VALUES (@user_id, @lat::float8, @lng::float8, @type, @desc, @status) '
        'RETURNING id, status, created_at',
      ),
      parameters: {
        'user_id': TypedValue(Type.uuid, userId),
        'lat': TypedValue(Type.text, latitude.toString()),
        'lng': TypedValue(Type.text, longitude.toString()),
        'type': TypedValue(Type.text, emergencyType),
        'desc': description == null || description.isEmpty
            ? null
            : TypedValue(Type.text, description),
        'status': TypedValue(Type.text, 'registered'),
      },
    );

    final row = result.first.toColumnMap();

    return Response.json(
      statusCode: HttpStatus.created,
      body: {
        'message': 'Alerta de pánico emitida',
        'alert': {
          'id': row['id'].toString(),
          'status': row['status'],
          'createdAt': (row['created_at'] as DateTime).toIso8601String(),
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
