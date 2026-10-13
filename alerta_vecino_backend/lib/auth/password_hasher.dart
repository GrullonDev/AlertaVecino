// Hashing de contraseñas de residentes.
import 'package:bcrypt/bcrypt.dart';

/// Genera el hash seguro de las contraseñas antes de persistirlas.
///
/// Se usa bcrypt con un `salt` aleatorio por contraseña porque es un algoritmo
/// pensado para credenciales: es lento de forma deliberada y con coste
/// configurable, a diferencia de hashes genéricos (SHA-256/512) que son
/// demasiado rápidos para almacenar contraseñas.
class PasswordHasher {
  PasswordHasher._();

  /// Devuelve el hash bcrypt de [plainPassword] listo para guardar en la BD.
  static String hash(String plainPassword) =>
      BCrypt.hashpw(plainPassword, BCrypt.gensalt());
}
