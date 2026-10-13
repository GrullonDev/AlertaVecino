// Comparación de contraseñas almacenadas.
import 'package:bcrypt/bcrypt.dart';

/// Verifica las contraseñas guardadas en la base de datos.
///
/// Las contraseñas nuevas se almacenan hasheadas con bcrypt (ver
/// `PasswordHasher`). Si el valor guardado no es un hash bcrypt se compara en
/// claro, respaldo que mantiene operativo al usuario semilla de desarrollo.
class PasswordVerifier {
  /// Compara [plainPassword] con el valor guardado en la base de datos.
  static bool verify({
    required String plainPassword,
    required String storedPassword,
  }) {
    if (_isBcryptHash(storedPassword)) {
      return BCrypt.checkpw(plainPassword, storedPassword);
    }
    // Respaldo para contraseñas sin hashear (usuario semilla de desarrollo).
    return storedPassword == plainPassword;
  }

  /// Un hash bcrypt siempre empieza por `$2a$`, `$2b$` o `$2y$`.
  static bool _isBcryptHash(String value) =>
      value.startsWith(r'$2a$') ||
      value.startsWith(r'$2b$') ||
      value.startsWith(r'$2y$');
}
