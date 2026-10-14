import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';

/// Consulta si un usuario registrado sigue pendiente de aprobación.
///
/// Acepta `GET /api/auth/pending_approval?email=<email>` y devuelve el estado
/// actual del usuario. No requiere JWT porque el usuario aún no tiene sesión.
Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final email = context
      .request.uri.queryParameters['email']
      ?.trim()
      .toLowerCase();

  if (email == null || email.isEmpty) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Se requiere el parámetro email'},
    );
  }

  try {
    final pool = context.read<Pool<dynamic>>();

    final result = await pool.execute(
      Sql.named(
        'SELECT status FROM users WHERE email = @email LIMIT 1',
      ),
      parameters: {'email': TypedValue(Type.text, email)},
    );

    if (result.isEmpty) {
      return Response.json(
        statusCode: HttpStatus.notFound,
        body: {'error': 'Usuario no encontrado'},
      );
    }

    final status = result.first.toColumnMap()['status'] as String? ?? 'pending';

    return Response.json(
      body: {
        'email': email,
        'status': status,
        'isPending': status == 'pending',
      },
    );
  } catch (_) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': 'Error interno del servidor'},
    );
  }
}
