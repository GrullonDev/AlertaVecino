import 'dart:io';

import 'package:alerta_vecino_backend/auth/jwt_service.dart';
import 'package:alerta_vecino_backend/auth/password_verifier.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';

/// Autentica a un residente y devuelve un JWT de sesión.
///
/// Espera un cuerpo JSON con `email` y `password`. Consulta la tabla `users`
/// de forma parametrizada (sin concatenar valores en el SQL) y responde con el
/// token y los datos básicos del usuario que consume la app Flutter.
Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  try {
    final body = await context.request.json() as Map<String, dynamic>;
    final email = (body['email'] as String?)?.trim().toLowerCase();
    final password = body['password'] as String?;

    if (email == null ||
        email.isEmpty ||
        password == null ||
        password.isEmpty) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {'error': 'Faltan campos obligatorios (email y password)'},
      );
    }

    final pool = context.read<Pool<dynamic>>();

    final result = await pool.execute(
      Sql.named(
        'SELECT id, email, password_hash, residency, house, status '
        'FROM users WHERE email = @email LIMIT 1',
      ),
      parameters: {'email': TypedValue(Type.text, email)},
    );

    if (result.isEmpty) {
      return Response.json(
        statusCode: HttpStatus.unauthorized,
        body: {'error': 'Credenciales inválidas'},
      );
    }

    final user = result.first.toColumnMap();
    final storedPassword = user['password_hash'] as String? ?? '';

    if (!PasswordVerifier.verify(
      plainPassword: password,
      storedPassword: storedPassword,
    )) {
      return Response.json(
        statusCode: HttpStatus.unauthorized,
        body: {'error': 'Credenciales inválidas'},
      );
    }

    final status = user['status'] as String? ?? 'approved';

    if (status == 'pending') {
      return Response.json(
        statusCode: HttpStatus.forbidden,
        body: {
          'error': 'Tu cuenta está pendiente de aprobación por la '
              'administración',
          'status': 'pending',
        },
      );
    }

    if (status == 'rejected') {
      return Response.json(
        statusCode: HttpStatus.forbidden,
        body: {
          'error': 'Tu solicitud de registro fue rechazada',
          'status': 'rejected',
        },
      );
    }

    final token = JwtService.issueSessionToken(
      userId: user['id'].toString(),
      email: user['email'] as String,
      residency: user['residency'] as String?,
      house: user['house'] as String?,
    );

    return Response.json(
      body: {
        'message': 'Login exitoso',
        'token': token,
        'status': status,
        'user': {
          'id': user['id'].toString(),
          'email': user['email'] as String?,
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
