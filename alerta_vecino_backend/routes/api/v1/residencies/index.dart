import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  try {
    final pool = context.read<Pool<dynamic>>();

    final result = await pool.execute(
      Sql.named(
        'SELECT id, name, location, resident_count '
        'FROM residencies '
        'WHERE is_active = TRUE '
        'ORDER BY name ASC',
      ),
    );

    final residencies = [
      for (final row in result)
        () {
          final m = row.toColumnMap();
          return {
            'id': m['id'].toString(),
            'name': m['name'],
            'location': m['location'],
            'residentCount': m['resident_count'],
          };
        }(),
    ];

    return Response.json(
      body: {
        'count': residencies.length,
        'residencies': residencies,
      },
    );
  } catch (_) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': 'Error interno del servidor'},
    );
  }
}
