import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';

/// Lista los usuarios registrados para revisión de la administración.
///
/// `GET /api/admin/users` devuelve todos los usuarios; con el query param
/// `?status=pending|approved|rejected` filtra por estado de verificación.
/// Requiere la cabecera `x-admin-key`.
Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final pool = context.read<Pool<dynamic>>();
  final statusFilter = context.request.uri.queryParameters['status']?.trim();

  const columns =
      'id, email, first_name, last_name, phone, residency, house, status, '
      'created_at';

  final Result result;
  if (statusFilter != null && statusFilter.isNotEmpty) {
    result = await pool.execute(
      Sql.named(
        'SELECT $columns FROM users WHERE status = @status '
        'ORDER BY created_at DESC',
      ),
      parameters: {'status': TypedValue(Type.text, statusFilter)},
    );
  } else {
    result = await pool.execute(
      Sql.named('SELECT $columns FROM users ORDER BY created_at DESC'),
    );
  }

  return Response.json(
    body: {
      'count': result.length,
      'users': [for (final row in result) _toJson(row.toColumnMap())],
    },
  );
}

Map<String, dynamic> _toJson(Map<String, dynamic> row) => {
  'id': row['id'].toString(),
  'email': row['email'],
  'firstName': row['first_name'],
  'lastName': row['last_name'],
  'phone': row['phone'],
  'residency': row['residency'],
  'house': row['house'],
  'status': row['status'],
  'createdAt': row['created_at']?.toString(),
};
