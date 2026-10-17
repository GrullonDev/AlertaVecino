import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';

/// Lista las alertas de pánico activas.
///
/// `GET /api/panic/active`
/// Requiere JWT. Devuelve las alertas con status `active` ordenadas de más
/// reciente a más antigua, incluyendo datos del usuario emisor.
Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  try {
    final pool = context.read<Pool<dynamic>>();

    final result = await pool.execute(
      Sql.named(
        'SELECT pa.id, pa.latitude, pa.longitude, pa.emergency_type, '
        'pa.description, pa.status, pa.created_at, '
        'u.id AS user_id, u.email, u.first_name, u.last_name, '
        'u.residency, u.house '
        'FROM panic_alerts pa '
        'JOIN users u ON u.id = pa.user_id '
        'WHERE pa.status != @status '
        'ORDER BY pa.created_at DESC',
      ),
      parameters: {
        'status': TypedValue(Type.text, 'resolved'),
      },
    );

    final alerts = [
      for (final row in result) _toJson(row.toColumnMap()),
    ];

    return Response.json(
      body: {
        'count': alerts.length,
        'alerts': alerts,
      },
    );
  } catch (_) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': 'Error interno del servidor'},
    );
  }
}

Map<String, dynamic> _toJson(Map<String, dynamic> row) => {
      'id': row['id'].toString(),
      'latitude': row['latitude'],
      'longitude': row['longitude'],
      'emergencyType': row['emergency_type'],
      'description': row['description'],
      'status': row['status'],
      'createdAt': (row['created_at'] as DateTime).toIso8601String(),
      'user': {
        'id': row['user_id'].toString(),
        'email': row['email'],
        'firstName': row['first_name'],
        'lastName': row['last_name'],
        'residency': row['residency'],
        'house': row['house'],
      },
    };
