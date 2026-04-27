import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Alerta Vecinos',
          style: GoogleFonts.abyssinicaSil(
            fontSize: 32,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w600,
            color: Colors.teal.shade700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Bienvenido de nuevo',
          style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
