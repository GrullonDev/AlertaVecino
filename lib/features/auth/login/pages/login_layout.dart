import 'package:flutter/material.dart';
import 'package:neighbour_alert/features/auth/login/widgets/login_divider.dart';
import 'package:neighbour_alert/features/auth/login/widgets/login_footer.dart';
import 'package:neighbour_alert/features/auth/login/widgets/login_form_fields.dart';
import 'package:neighbour_alert/features/auth/login/widgets/login_header.dart';
import 'package:neighbour_alert/features/auth/login/widgets/login_remember_row.dart';
import 'package:neighbour_alert/features/auth/login/widgets/option_login.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';
import 'package:neighbour_alert/utils/router/route_path.dart';

class LoginLayout extends StatefulWidget {
  const LoginLayout({super.key});

  @override
  State<LoginLayout> createState() => _LoginLayoutState();
}

class _LoginLayoutState extends State<LoginLayout> {
  final _formKey = GlobalKey<FormState>();

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        RoutePath.home,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
          border: Border.all(color: cs.outline),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(child: LoginHeader()),
              const SizedBox(height: 32),
              const LoginFormFields(),
              const SizedBox(height: 8),
              const LoginRememberRow(),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _handleLogin,
                child: Text(l10n.login),
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
      ),
    );
  }
}
