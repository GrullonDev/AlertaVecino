import 'package:flutter/material.dart';
import 'package:neighbour_alert/features/auth/register/widgets/register_text_field.dart';

class RegisterFormFields extends StatelessWidget {
  const RegisterFormFields({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const RegisterTextField(
          label: 'Nombre completo',
          icon: Icons.person_outline,
          keyboardType: TextInputType.name,
        ),
        const SizedBox(height: 16),
        const RegisterTextField(
          label: 'Correo electrónico',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        const RegisterTextField(
          label: 'Número de teléfono',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        RegisterTextField(
          label: 'Contraseña',
          icon: Icons.lock_outline,
          obscureText: true,
          suffixIcon: IconButton(
            icon: const Icon(Icons.visibility_off_outlined),
            onPressed: () {},
          ),
        ),
        const SizedBox(height: 16),
        const RegisterTextField(
          label: 'Departamento / Municipio',
          icon: Icons.map_outlined,
        ),
        const SizedBox(height: 16),
        const RegisterTextField(
          label: 'Colonia o Residencial',
          icon: Icons.location_city_outlined,
        ),
        const SizedBox(height: 16),
        const RegisterTextField(
          label: 'Sector, fase, bloque o calle',
          icon: Icons.signpost_outlined,
        ),
        const SizedBox(height: 16),
        const RegisterTextField(
          label: 'Número de casa/apartamento (Opcional)',
          icon: Icons.home_outlined,
        ),
        const SizedBox(height: 16),
        const RegisterTextField(
          label: 'Documento de verificación',
          icon: Icons.document_scanner_outlined,
          helperText:
              'Recibo de agua/luz, constancia de residencia o código de invitación',
        ),
      ],
    );
  }
}
