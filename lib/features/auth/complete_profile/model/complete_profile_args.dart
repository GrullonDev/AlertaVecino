/// Datos de sesión necesarios para completar el perfil de un usuario que ya
/// inició sesión pero aún no tiene residencia ni unidad asignadas.
class ProfileCompletionArgs {
  const ProfileCompletionArgs({required this.token, required this.userId});

  /// JWT de sesión emitido por el login; viaja en la cabecera Authorization.
  final String token;

  /// Identificador del usuario autenticado; viaja en el cuerpo de la petición.
  final String userId;
}
