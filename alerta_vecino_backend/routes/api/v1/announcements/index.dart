import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';

/// Lista los comunicados oficiales.
///
/// `GET /api/v1/announcements`
/// Requiere JWT. Acepta el query param `?category=urgent|maintenance|info`
/// para filtrar por tipo. Devuelve los comunicados más recientes primero,
/// incluyendo el nombre del autor.
Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  try {
    final pool = context.read<Pool<dynamic>>();
    final category =
        context.request.uri.queryParameters['category']?.trim();

    const columns =
        'a.id, a.title, a.body, a.category, a.image_url, a.pdf_url, '
        'a.created_at, a.updated_at, '
        'u.id AS author_id, u.first_name, u.last_name';

    final Result result;
    if (category != null && category.isNotEmpty) {
      result = await pool.execute(
        Sql.named(
          'SELECT $columns FROM announcements a '
          'JOIN users u ON u.id = a.author_id '
          'WHERE a.category = @category '
          'ORDER BY a.created_at DESC',
        ),
        parameters: {'category': TypedValue(Type.text, category)},
      );
    } else {
      result = await pool.execute(
        Sql.named(
          'SELECT $columns FROM announcements a '
          'JOIN users u ON u.id = a.author_id '
          'ORDER BY a.created_at DESC',
        ),
      );
    }

    final announcements = [
      for (final row in result) _toJson(row.toColumnMap()),
    ];

    return Response.json(
      body: {
        'count': announcements.length,
        'announcements': announcements,
      },
    );
  } catch (_) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': 'Error interno del servidor'},
    );
  }
}

Map<String, dynamic> _toJson(Map<String, dynamic> row) {
  final firstName = row['first_name'] as String? ?? '';
  final lastName = row['last_name'] as String? ?? '';
  final author = '$firstName $lastName'.trim();

  return {
    'id': row['id'].toString(),
    'title': row['title'],
    'body': row['body'],
    'category': row['category'],
    'author': author.isEmpty ? 'Administración' : author,
    'imageUrl': row['image_url'],
    'pdfUrl': row['pdf_url'],
    'publishedAt': (row['created_at'] as DateTime).toIso8601String(),
    'updatedAt': (row['updated_at'] as DateTime).toIso8601String(),
  };
}
