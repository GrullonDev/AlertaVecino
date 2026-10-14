import 'dart:io';

import 'package:alerta_vecino_backend/auth/password_hasher.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';

/// Crea un usuario directamente con el estado deseado.
///
/// `POST /api/admin/users/create`
/// Requiere la cabecera `x-admin-key`.
///
/// Body JSON:
/// ```json
/// {
///   "email": "user@example.com",
///   "password": "secret123",
///   "firstName": "John",
///   "lastName": "Doe",
///   "phone": "+1234567890",
///   "residency": "Residencial Los Pinos",
///   "house": "A-12",
///   "status": "approved"
/// }
/// ```
///
/// `status` es opcional y por defecto es `approved` (a diferencia del
/// registro público que deja al usuario como `pending`).
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
        body: {
          'error': 'El cuerpo debe ser un objeto JSON',
        },
      );
    }
    body = decoded;
  } on FormatException {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Formato JSON inválido'},
    );
  }

  final email = (body['email'] as String?)?.trim().toLowerCase();
  final password = body['password'] as String?;

  if (email == null ||
      email.isEmpty ||
      password == null ||
      password.isEmpty) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Faltan campos obligatorios (email, password)'},
    );
  }

  final firstName = (body['firstName'] as String?)?.trim();
  final lastName = (body['lastName'] as String?)?.trim();
  final phone = (body['phone'] as String?)?.trim();
  final residency = (body['residency'] as String?)?.trim();
  final house = (body['house'] as String?)?.trim();
  final status = (body['status'] as String?)?.trim() ?? 'approved';

  final passwordHash = PasswordHasher.hash(password);

  final pool = context.read<Pool<dynamic>>();

  try {
    final result = await pool.execute(
      Sql.named(
        'INSERT INTO users '
        '(email, password_hash, first_name, last_name, phone, '
        'residency, house, status, is_active) '
        'VALUES (@email, @hash, @first, @last, @phone, '
        '@residency, @house, @status, TRUE) '
        'RETURNING id, email, first_name, last_name, phone, '
        'residency, house, status',
      ),
      parameters: {
        'email': TypedValue(Type.text, email),
        'hash': TypedValue(Type.text, passwordHash),
        'first': firstName == null
            ? null
            : TypedValue(Type.text, firstName),
        'last': lastName == null
            ? null
            : TypedValue(Type.text, lastName),
        'phone': phone == null
            ? null
            : TypedValue(Type.text, phone),
        'residency': residency == null
            ? null
            : TypedValue(Type.text, residency),
        'house': house == null
            ? null
            : TypedValue(Type.text, house),
        'status': TypedValue(Type.text, status),
      },
    );

    final user = result.first.toColumnMap();

    return Response.json(
      statusCode: HttpStatus.created,
      body: {
        'message': 'Usuario creado',
        'user': {
          'id': user['id'].toString(),
          'email': user['email'],
          'firstName': user['first_name'],
          'lastName': user['last_name'],
          'phone': user['phone'],
          'residency': user['residency'],
          'house': user['house'],
          'status': user['status'],
        },
      },
    );
  } on ServerException catch (_) {
    return Response.json(
      statusCode: HttpStatus.conflict,
      body: {'error': 'Ya existe un usuario con ese email'},
    );
  } catch (_) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': 'Error interno del servidor'},
    );
  }
}
