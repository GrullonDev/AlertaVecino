import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  // 1. Validar que la petición sea estrictamente POST
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  try {
    // 2. Leer el cuerpo de la petición enviado por Flutter (JSON)
    final body = await context.request.json() as Map<String, dynamic>;
    final email = body['email'] as String?;
    final password = body['password'] as String?;

    // 3. Validar que los campos no vengan vacíos
    if (email == null || password == null || email.isEmpty || password.isEmpty) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {
          'error': 'Faltan campos obligatorios (email y password)'
        },
      );
    }

    //? TODO: Aquí en el futuro conectarás tu validación de base de datos y generación real del JWT

    // 4. Responder con éxito simulando la entrega del Token
    return Response.json(
      body: {
        'message': 'Login exitoso',
        'token': 'jwt_token_ejemplo_12345',
        'user': {
          'email': email,
          'residency': 'Residencial Los Sauces',
          'house': 'Casa #42',
        },
      },
    );
  } catch (e) {
    // Manejo de errores si el JSON viene malformado
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {
        'error': 'Formato JSON inválido o error en el servidor'
      },
    );
  }
}
