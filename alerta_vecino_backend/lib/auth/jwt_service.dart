// Emisión de JSON Web Tokens de sesión.
import 'package:alerta_vecino_backend/config/env.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

/// Servicio responsable de firmar los tokens de sesión de los residentes.
class JwtService {
  /// Emite un token firmado (HS256) con los datos básicos del usuario.
  ///
  /// El identificador viaja en el claim estándar `sub`; los datos de
  /// residencia se incluyen como claims personalizados para que el cliente no
  /// tenga que consultarlos por separado.
  static String issueSessionToken({
    required String userId,
    required String email,
    String? residency,
    String? house,
  }) {
    final jwt = JWT(
      {
        'email': email,
        'residency': residency,
        'house': house,
      },
      subject: userId,
      issuer: 'alerta_vecino_backend',
    );

    return jwt.sign(
      SecretKey(Env.jwtSecret),
      expiresIn: const Duration(hours: 24),
    );
  }
}
