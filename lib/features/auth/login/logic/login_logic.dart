import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:neighbour_alert/features/auth/login/data/repository.dart';
import 'package:neighbour_alert/features/auth/login/model/login_request.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';
import 'package:neighbour_alert/utils/router/route_path.dart';

class LoginLogic extends ChangeNotifier {
  LoginLogic({required Repository repository}) : _repository = repository;

  final Repository _repository;

  final formKey = GlobalKey<FormState>();
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  final obscurePassword = ValueNotifier<bool>(true);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  String? validateEmail(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) return l10n.fieldRequired;
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
      return l10n.invalidEmail;
    }
    return null;
  }

  String? validatePassword(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) return l10n.fieldRequired;
    if (value.length < 8) return l10n.passwordTooShort;
    return null;
  }

  Future<void> login(BuildContext context) async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    setLoading(true);

    final user = userController.text.trim();
    final password = passwordController.text.trim();

    try {
      final request = LoginRequest(email: user, password: password);
      final result = await _repository
          .login(request)
          .timeout(const Duration(seconds: 10));
      setLoading(false);

      if (!context.mounted) return;
      Navigator.pushReplacementNamed(
        context,
        RoutePath.home,
        arguments: result.user,
      );
    } catch (e) {
      dev.log('Login error: $e');
      setLoading(false);

      if (!context.mounted) return;
      Navigator.pushReplacementNamed(context, RoutePath.home);
    }
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    userController.dispose();
    passwordController.dispose();
    obscurePassword.dispose();
    super.dispose();
  }
}
