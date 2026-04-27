import 'package:flutter/material.dart';
import 'package:neighbour_alert/utils/router/route_path.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            Text(
              '¿Nuevo en Alerta Vecinos? ',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, RoutePath.register),
              child: Text(
                'Solicitar acceso como vecino',
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.info, color: Colors.blue.shade700, size: 16),
              const SizedBox(width: 8),
              Text(
                'Tus datos están protegidos y verificados',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
