import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:neighbour_alert/features/auth/complete_profile/model/complete_profile_args.dart';
import 'package:neighbour_alert/features/auth/login/data/repository.dart';
import 'package:neighbour_alert/features/auth/login/model/login_error.dart';
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

  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

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

    final l10n = AppLocalizations.of(context)!;
    setError(null);
    setLoading(true);

    final user = userController.text.trim();
    final password = passwordController.text.trim();

    try {
      final request = LoginRequest(email: user, password: password);
      final result = await _repository.login(request);

      if (!result.isValid) {
        throw const LoginException(LoginErrorType.badResponse);
      }

      if (!context.mounted) return;
      setLoading(false);
      if (result.user.hasCompleteProfile) {
        Navigator.pushReplacementNamed(
          context,
          RoutePath.home,
          arguments: result.user,
        );
      } else {
        Navigator.pushReplacementNamed(
          context,
          RoutePath.completeProfile,
          arguments: ProfileCompletionArgs(
            token: result.token,
            userId: result.user.id,
          ),
        );
      }
    } on LoginException catch (e) {
      dev.log('Login error: $e');
      if (!context.mounted) return;
      setLoading(false);
      setError(_messageFor(e, l10n));
    } catch (e) {
      dev.log('Login error inesperado: $e');
      if (!context.mounted) return;
      setLoading(false);
      setError(l10n.loginErrorUnexpected);
    }
  }

  String _messageFor(LoginException error, AppLocalizations l10n) {
    switch (error.type) {
      case LoginErrorType.invalidCredentials:
      case LoginErrorType.notFound:
        return l10n.loginErrorInvalidCredentials;
      case LoginErrorType.validation:
        return error.serverMessage ?? l10n.loginErrorValidation;
      case LoginErrorType.conflict:
        return error.serverMessage ?? l10n.loginErrorConflict;
      case LoginErrorType.server:
        return l10n.loginErrorServer;
      case LoginErrorType.timeout:
        return l10n.loginErrorTimeout;
      case LoginErrorType.connection:
        return l10n.loginErrorConnection;
      case LoginErrorType.badResponse:
        return l10n.loginErrorBadResponse;
      case LoginErrorType.unknown:
        return l10n.loginErrorUnexpected;
    }
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(String? value) {
    if (_errorMessage == value) return;
    _errorMessage = value;
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
