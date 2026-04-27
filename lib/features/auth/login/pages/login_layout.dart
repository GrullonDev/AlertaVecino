import 'package:flutter/material.dart';
import 'package:neighbour_alert/features/auth/login/widgets/login_divider.dart';
import 'package:neighbour_alert/features/auth/login/widgets/login_footer.dart';
import 'package:neighbour_alert/features/auth/login/widgets/login_form_fields.dart';
import 'package:neighbour_alert/features/auth/login/widgets/login_header.dart';
import 'package:neighbour_alert/features/auth/login/widgets/login_remember_row.dart';
import 'package:neighbour_alert/features/auth/login/widgets/option_login.dart';

class LoginLayout extends StatelessWidget {
  const LoginLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
          border: Border.all(color: Colors.teal.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Center(child: LoginHeader()),
            const SizedBox(height: 32),
            const LoginFormFields(),
            const SizedBox(height: 8),
            const LoginRememberRow(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: const Text(
                'Iniciar Sesión',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            const LoginDivider(),
            const SizedBox(height: 24),
            const OptionsLogin(),
            const SizedBox(height: 32),
            const Center(child: LoginFooter()),
          ],
        ),
      ),
    );
  }
}
