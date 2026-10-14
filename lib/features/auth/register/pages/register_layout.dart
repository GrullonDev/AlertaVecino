import 'package:flutter/material.dart';
import 'package:neighbour_alert/features/auth/register/model/registration_draft.dart';
import 'package:neighbour_alert/features/auth/register/widgets/register_footer.dart';
import 'package:neighbour_alert/features/auth/register/widgets/register_form_fields.dart';
import 'package:neighbour_alert/features/auth/register/widgets/register_header.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';
import 'package:neighbour_alert/utils/router/route_path.dart';

class RegisterLayout extends StatefulWidget {
  const RegisterLayout({super.key});

  @override
  State<RegisterLayout> createState() => _RegisterLayoutState();
}

class _RegisterLayoutState extends State<RegisterLayout> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final draft = RegistrationDraft(
      fullName: _fullNameController.text.trim(),
      email: _emailController.text.trim().toLowerCase(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
    );

    Navigator.pushNamed(context, RoutePath.selectResidency, arguments: draft);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
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
              const Center(child: RegisterHeader()),
              const SizedBox(height: 32),
              RegisterFormFields(
                fullNameController: _fullNameController,
                emailController: _emailController,
                phoneController: _phoneController,
                passwordController: _passwordController,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _handleRegister,
                child: Text(l10n.continueButton),
              ),
              const SizedBox(height: 24),
              const Center(child: RegisterFooter()),
            ],
          ),
        ),
      ),
    );
  }
}
