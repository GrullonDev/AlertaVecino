import 'package:flutter/material.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';

class LoginFormFields extends StatelessWidget {
  const LoginFormFields({
    super.key,
    required this.userController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onToggleObscure,
    required this.emailValidator,
    required this.passwordValidator,
  });

  final TextEditingController userController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onToggleObscure;
  final FormFieldValidator<String> emailValidator;
  final FormFieldValidator<String> passwordValidator;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    return Column(
      children: [
        TextFormField(
          controller: userController,
          decoration: InputDecoration(
            labelText: l10n.email,
            prefixIcon: Icon(Icons.email_outlined, color: cs.primary),
          ),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator: emailValidator,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: passwordController,
          decoration: InputDecoration(
            labelText: l10n.password,
            prefixIcon: Icon(Icons.lock_outline, color: cs.primary),
            suffixIcon: IconButton(
              icon: Icon(
                obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
              onPressed: onToggleObscure,
            ),
          ),
          obscureText: obscurePassword,
          textInputAction: TextInputAction.done,
          validator: passwordValidator,
        ),
      ],
    );
  }
}
