import 'dart:io';

import 'package:alerta_vecino_backend/auth/jwt_service.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';

/// Asocia o cambia la residencia activa de un usuario autenticado.
///
/// Espera un cuerpo JSON con `residency` y `house`. Lee el userId del payload
/// JWT inyectado por el middleware. Devuelve los datos actualizados y un token
/// renovado con las claims de residencia actualizadas.
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
    final residency = (body['residency'] as String?)?.trim();
    final house = (body['house'] as String?)?.trim();

    if (residency == null ||
        residency.isEmpty ||
        house == null ||
        house.isEmpty) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {'error': 'Faltan la residencia y la unidad'},
      );
    }

    final pool = context.read<Pool<dynamic>>();

    final result = await pool.execute(
      Sql.named(
        'UPDATE users SET residency = @residency, house = @house '
        'WHERE id = @id '
        'RETURNING id, email, residency, house',
      ),
      parameters: {
        'id': TypedValue(Type.uuid, userId),
        'residency': TypedValue(Type.text, residency),
        'house': TypedValue(Type.text, house),
      },
    );

    if (result.isEmpty) {
      return Response.json(
        statusCode: HttpStatus.notFound,
        body: {'error': 'Usuario no encontrado'},
      );
    }

    final user = result.first.toColumnMap();
    final email = user['email'] as String;

    final renewedToken = JwtService.issueSessionToken(
      userId: user['id'].toString(),
      email: email,
      residency: user['residency'] as String?,
      house: user['house'] as String?,
      role: (payload['role'] as String?) ?? 'resident',
    );

    return Response.json(
      body: {
        'message': 'Residencia actualizada',
        'token': renewedToken,
        'user': {
          'id': user['id'].toString(),
          'email': email,
          'residency': user['residency'] as String?,
          'house': user['house'] as String?,
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
