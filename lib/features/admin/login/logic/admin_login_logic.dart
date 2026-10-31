import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:neighbour_alert/core/session/session_service.dart';
import 'package:neighbour_alert/features/auth/login/data/repository.dart';
import 'package:neighbour_alert/features/auth/login/model/login_error.dart';
import 'package:neighbour_alert/features/auth/login/model/login_request.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';
import 'package:neighbour_alert/utils/router/route_path.dart';

class AdminLoginLogic extends ChangeNotifier {
  AdminLoginLogic({
    required Repository repository,
    required SessionService sessionService,
  })  : _repository = repository,
        _sessionService = sessionService;

  final Repository _repository;
  final SessionService _sessionService;

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
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
    _setError(null);
    _setLoading(true);

    try {
      final request = LoginRequest(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      final result = await _repository.login(request);

      if (!result.isValid) {
        throw const LoginException(LoginErrorType.badResponse);
      }

      if (result.user.role != 'admin') {
        _setLoading(false);
        _setError(l10n.adminNotAuthorized);
        return;
      }

      await _sessionService.saveSession(
        token: result.token,
        user: result.user,
      );

      if (!context.mounted) return;
      _setLoading(false);
      Navigator.pushReplacementNamed(context, RoutePath.adminDashboard);
    } on LoginException catch (e) {
      dev.log('Admin login error: $e');
      if (!context.mounted) return;
      _setLoading(false);
      _setError(_messageFor(e, l10n));
    } catch (e) {
      dev.log('Admin login unexpected error: $e');
      if (!context.mounted) return;
      _setLoading(false);
      _setError(l10n.loginErrorUnexpected);
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

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    if (_errorMessage == value) return;
    _errorMessage = value;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    obscurePassword.dispose();
    super.dispose();
  }
}
