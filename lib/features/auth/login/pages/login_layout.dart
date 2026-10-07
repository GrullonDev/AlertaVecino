import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:neighbour_alert/features/auth/login/logic/login_logic.dart';
import 'package:neighbour_alert/features/auth/login/widgets/login_divider.dart';
import 'package:neighbour_alert/features/auth/login/widgets/login_footer.dart';
import 'package:neighbour_alert/features/auth/login/widgets/login_form_fields.dart';
import 'package:neighbour_alert/features/auth/login/widgets/login_header.dart';
import 'package:neighbour_alert/features/auth/login/widgets/login_remember_row.dart';
import 'package:neighbour_alert/features/auth/login/widgets/option_login.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';

class LoginLayout extends StatelessWidget {
  const LoginLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    return Consumer<LoginLogic>(
      builder: (context, logic, child) => SingleChildScrollView(
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
            key: logic.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Center(child: LoginHeader()),
                const SizedBox(height: 32),
                ValueListenableBuilder<bool>(
                  valueListenable: logic.obscurePassword,
                  builder: (context, obscure, _) => LoginFormFields(
                    userController: logic.userController,
                    passwordController: logic.passwordController,
                    obscurePassword: obscure,
                    onToggleObscure: logic.togglePasswordVisibility,
                    emailValidator: (v) => logic.validateEmail(v, l10n),
                    passwordValidator: (v) => logic.validatePassword(v, l10n),
                  ),
                ),
                const SizedBox(height: 8),
                const LoginRememberRow(),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => logic.login(context),
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
      ),
    );
  }
}
