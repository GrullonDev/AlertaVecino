import 'package:flutter/material.dart';
import 'package:neighbour_alert/features/auth/register/widgets/register_text_field.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';

class RegisterFormFields extends StatefulWidget {
  const RegisterFormFields({super.key});

  @override
  State<RegisterFormFields> createState() => _RegisterFormFieldsState();
}

class _RegisterFormFieldsState extends State<RegisterFormFields> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        RegisterTextField(
          label: l10n.fullName,
          icon: Icons.person_outline,
          keyboardType: TextInputType.name,
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? l10n.fieldRequired : null,
        ),
        const SizedBox(height: 16),
        RegisterTextField(
          label: l10n.emailLower,
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: (v) {
            if (v == null || v.trim().isEmpty) return l10n.fieldRequired;
            if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v)) {
              return l10n.invalidEmail;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        RegisterTextField(
          label: l10n.phoneNumber,
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          validator: (v) {
            if (v == null || v.trim().isEmpty) return l10n.fieldRequired;
            if (v.trim().length < 8) return l10n.invalidPhone;
            return null;
          },
        ),
        const SizedBox(height: 16),
        RegisterTextField(
          label: l10n.password,
          icon: Icons.lock_outline,
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.done,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
            onPressed: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),
          validator: (v) {
            if (v == null || v.isEmpty) return l10n.fieldRequired;
            if (v.length < 8) return l10n.passwordTooShort;
            return null;
          },
        ),
      ],
    );
  }
}
