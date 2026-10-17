import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';

/// Crea un comunicado oficial.
///
/// `POST /api/v1/admin/announcements/create`
/// Requiere cabecera `x-admin-key`.
/// Body: `{ "author_id", "title", "body", "category"?,
///   "image_url"?, "pdf_url"? }`
Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final Map<String, dynamic> body;
  try {
    final decoded = await context.request.json();
    if (decoded is! Map<String, dynamic>) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {'error': 'El cuerpo de la petición debe ser un objeto JSON'},
      );
    }
    body = decoded;
  } on FormatException {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Formato JSON inválido'},
    );
  }

  final authorId = (body['author_id'] as String?)?.trim();
  final title = (body['title'] as String?)?.trim();
  final announcementBody = (body['body'] as String?)?.trim();
  final category = (body['category'] as String?)?.trim() ?? 'info';
  final imageUrl = (body['image_url'] as String?)?.trim();
  final pdfUrl = (body['pdf_url'] as String?)?.trim();

  if (authorId == null || authorId.isEmpty) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Falta el author_id'},
    );
  }

  if (title == null || title.isEmpty) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Falta el título'},
    );
  }

  if (announcementBody == null || announcementBody.isEmpty) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Falta el cuerpo del comunicado'},
    );
  }

  const validCategories = ['urgent', 'maintenance', 'info'];
  if (!validCategories.contains(category)) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {
        'error': 'category inválido. '
            'Valores aceptados: ${validCategories.join(", ")}',
      },
    );
  }

  try {
    final pool = context.read<Pool<dynamic>>();

    final result = await pool.execute(
      Sql.named(
        'INSERT INTO announcements '
        '(author_id, title, body, category, image_url, pdf_url) '
        'VALUES (@author_id, @title, @body, @category, @image_url, @pdf_url) '
        'RETURNING id, created_at',
      ),
      parameters: {
        'author_id': TypedValue(Type.uuid, authorId),
        'title': TypedValue(Type.text, title),
        'body': TypedValue(Type.text, announcementBody),
        'category': TypedValue(Type.text, category),
        'image_url': _textOrNull(imageUrl),
        'pdf_url': _textOrNull(pdfUrl),
      },
    );

    final row = result.first.toColumnMap();

    return Response.json(
      statusCode: HttpStatus.created,
      body: {
        'message': 'Comunicado creado',
        'announcement': {
          'id': row['id'].toString(),
          'createdAt': (row['created_at'] as DateTime).toIso8601String(),
        },
      },
    );
  } catch (_) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': 'Error interno del servidor'},
    );
  }
}

TypedValue? _textOrNull(String? value) =>
    (value == null || value.isEmpty) ? null : TypedValue(Type.text, value);
