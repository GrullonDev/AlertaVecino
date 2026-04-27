import 'package:flutter/material.dart';

class LoginRememberRow extends StatelessWidget {
  const LoginRememberRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          children: [
            Checkbox(
              value: false,
              onChanged: (value) {},
              activeColor: Colors.teal,
            ),
            Text(
              'Mantener sesión iniciada',
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ],
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            '¿Olvidaste tu contraseña?',
            style: TextStyle(color: Colors.teal.shade600),
          ),
        ),
      ],
    );
  }
}
