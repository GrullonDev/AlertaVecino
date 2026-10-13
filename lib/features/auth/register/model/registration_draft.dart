/// Datos capturados en el formulario de registro antes de elegir la residencia.
///
/// Se crea en la pantalla de registro y se pasa como argumento de navegación a
/// la pantalla de selección de residencia, donde se completa y se envía al
/// backend.
class RegistrationDraft {
  const RegistrationDraft({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
  });

  final String fullName;
  final String email;
  final String phone;
  final String password;
}
