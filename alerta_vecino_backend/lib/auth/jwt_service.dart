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

  /// Verifica un token de sesión y devuelve sus claims.
  ///
  /// Devuelve `null` si el token es inválido, ha expirado o fue firmado con
  /// otra llave, para que el llamador responda `401` sin filtrar detalles.
  static Map<String, dynamic>? verifySessionToken(String token) {
    try {
      final jwt = JWT.verify(token, SecretKey(Env.jwtSecret));
      final payload = jwt.payload;
      if (payload is Map) {
        return Map<String, dynamic>.from(payload);
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
