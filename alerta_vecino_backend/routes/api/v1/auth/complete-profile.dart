import 'dart:io';

import 'package:alerta_vecino_backend/auth/jwt_service.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';

/// Completa el perfil (residencia y unidad) de un residente ya autenticado.
///
/// Se usa cuando un usuario puede iniciar sesión pero su perfil aún no tiene
/// residencia o unidad asignada. La petición debe incluir:
///   - Cabecera `Authorization: Bearer <token>` con el JWT de sesión.
///   - Cuerpo JSON con `id` (identificador del usuario), `residency` y `house`.
///
/// El `id` enviado debe coincidir con el `sub` del token para evitar que un
/// usuario autenticado modifique el perfil de otro.
///
/// Responde `200` con el usuario actualizado y un token renovado, `400` si
/// faltan datos, `401` si el token es inválido o el `id` no coincide, o `404`
/// si el usuario no existe.
Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final token = _bearerToken(
    context.request.headers['authorization'] ??
        context.request.headers['Authorization'],
  );
  if (token == null) {
    return _unauthorized();
  }

  final payload = JwtService.verifySessionToken(token);
  if (payload == null) {
    return _unauthorized();
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

  final userId = (body['id'] as String?)?.trim();
  if (userId == null || userId.isEmpty) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Falta el id del usuario'},
    );
  }

  if ((payload['sub'] as String?) != userId) {
    return _unauthorized();
  }

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

  try {
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
        'message': 'Perfil completado',
        'token': renewedToken,
        'user': {
          'id': user['id'].toString(),
          'email': email,
          'residency': user['residency'] as String?,
          'house': user['house'] as String?,
        },
      },
    );
  } catch (_) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Identificador de usuario inválido'},
    );
  }
}

Response _unauthorized() => Response.json(
  statusCode: HttpStatus.unauthorized,
  body: {'error': 'No autorizado'},
);

/// Extrae el token de una cabecera `Authorization: Bearer <token>`.
String? _bearerToken(String? header) {
  if (header == null) return null;
  const prefix = 'Bearer ';
  if (!header.startsWith(prefix)) return null;
  final token = header.substring(prefix.length).trim();
  return token.isEmpty ? null : token;
}
