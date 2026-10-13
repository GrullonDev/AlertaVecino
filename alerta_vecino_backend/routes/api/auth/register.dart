import 'dart:io';

import 'package:alerta_vecino_backend/auth/password_hasher.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';

/// Crea la solicitud de registro de un nuevo residente en la tabla `users`.
///
/// Espera un cuerpo JSON con `email` y `password` (obligatorios) y
/// opcionalmente `fullName`, `phone`, `residency` y `house`. La contraseña se
/// persiste hasheada con bcrypt (nunca en texto plano) y el `INSERT` es
/// parametrizado para evitar inyección SQL.
///
/// El usuario se crea en estado `pending`: la administración debe aprobarlo
/// (ver `/api/admin/users/:id/approve`) antes de que pueda iniciar sesión.
/// Responde `201 Created`, `409 Conflict` si el correo ya existe o
/// `400 Bad Request` si el payload es inválido.
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

  final fullName = (body['fullName'] as String?)?.trim() ?? '';
  final nameParts = fullName
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .toList();
  final firstName =
      (body['firstName'] as String?)?.trim() ??
      (nameParts.isNotEmpty ? nameParts.first : '');
  final lastName =
      (body['lastName'] as String?)?.trim() ??
      (nameParts.length > 1 ? nameParts.skip(1).join(' ') : '');

  final phone = (body['phone'] as String?)?.trim();
  final residency = (body['residency'] as String?)?.trim();
  final house = (body['house'] as String?)?.trim();

  try {
    final pool = context.read<Pool<dynamic>>();
    final passwordHash = PasswordHasher.hash(password);

    final result = await pool.execute(
      Sql.named(
        'INSERT INTO users '
        '(email, password_hash, first_name, last_name, phone, residency, '
        'house, status) '
        'VALUES (@email, @password_hash, @first_name, @last_name, @phone, '
        '@residency, @house, @status) '
        'RETURNING id, email, status, created_at',
      ),
      parameters: {
        'email': TypedValue(Type.text, email),
        'password_hash': TypedValue(Type.text, passwordHash),
        'first_name': _textOrNull(firstName),
        'last_name': _textOrNull(lastName),
        'phone': _textOrNull(phone),
        'residency': _textOrNull(residency),
        'house': _textOrNull(house),
        'status': TypedValue(Type.text, 'pending'),
      },
    );

    final user = result.first.toColumnMap();

    return Response.json(
      statusCode: HttpStatus.created,
      body: {
        'message':
            'Solicitud enviada. Tu cuenta está pendiente de aprobación.',
        'user': {
          'id': user['id'].toString(),
          'email': user['email'] as String?,
          'status': user['status'] as String?,
          'createdAt': user['created_at']?.toString(),
        },
      },
    );
  } on UniqueViolationException {
    return Response.json(
      statusCode: HttpStatus.conflict,
      body: {'error': 'El correo ya está registrado'},
    );
  } catch (_) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': 'Error interno del servidor'},
    );
  }
}

/// Convierte un valor de texto vacío en `NULL` para no guardar cadenas vacías.
TypedValue? _textOrNull(String? value) =>
    (value == null || value.isEmpty) ? null : TypedValue(Type.text, value);
