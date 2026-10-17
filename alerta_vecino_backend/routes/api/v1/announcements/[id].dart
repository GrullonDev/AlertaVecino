import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';

/// Devuelve un comunicado por su identificador.
///
/// `GET /api/v1/announcements/<id>`
/// Requiere JWT.
Future<Response> onRequest(RequestContext context, String id) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final announcementId = id.trim();
  if (announcementId.isEmpty) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Falta el id del comunicado'},
    );
  }

  try {
    final pool = context.read<Pool<dynamic>>();

    final result = await pool.execute(
      Sql.named(
        'SELECT a.id, a.title, a.body, a.category, a.image_url, '
        'a.pdf_url, a.created_at, a.updated_at, '
        'u.id AS author_id, u.first_name, u.last_name '
        'FROM announcements a '
        'JOIN users u ON u.id = a.author_id '
        'WHERE a.id = @id LIMIT 1',
      ),
      parameters: {'id': TypedValue(Type.uuid, announcementId)},
    );

    if (result.isEmpty) {
      return Response.json(
        statusCode: HttpStatus.notFound,
        body: {'error': 'Comunicado no encontrado'},
      );
    }

    final row = result.first.toColumnMap();
    final firstName = row['first_name'] as String? ?? '';
    final lastName = row['last_name'] as String? ?? '';
    final author = '$firstName $lastName'.trim();

    return Response.json(
      body: {
        'announcement': {
          'id': row['id'].toString(),
          'title': row['title'],
          'body': row['body'],
          'category': row['category'],
          'author': author.isEmpty ? 'Administración' : author,
          'imageUrl': row['image_url'],
          'pdfUrl': row['pdf_url'],
          'publishedAt':
              (row['created_at'] as DateTime).toIso8601String(),
          'updatedAt':
              (row['updated_at'] as DateTime).toIso8601String(),
        },
      },
    );
  } catch (_) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Identificador de comunicado inválido'},
    );
  }
}
