import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:neighbour_alert/features/auth/register/data/repository.dart';
import 'package:neighbour_alert/features/auth/register/model/register_error.dart';
import 'package:neighbour_alert/features/auth/register/model/registration_draft.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';

class RegisterLogic extends ChangeNotifier {
  RegisterLogic({required RegisterRepository repository})
    : _repository = repository;

  final RegisterRepository _repository;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  /// Envía la solicitud de registro. Devuelve `true` si fue exitosa.
  Future<bool> register({
    required RegistrationDraft draft,
    required AppLocalizations l10n,
    String? residency,
    String? house,
  }) async {
    setError(null);
    setLoading(true);

    try {
      await _repository.register(draft, residency: residency, house: house);
      setLoading(false);
      return true;
    } on RegisterException catch (e) {
      dev.log('Register error: $e');
      setLoading(false);
      setError(_messageFor(e, l10n));
      return false;
    } catch (e) {
      dev.log('Register error inesperado: $e');
      setLoading(false);
      setError(l10n.registerErrorUnexpected);
      return false;
    }
  }

  String _messageFor(RegisterException error, AppLocalizations l10n) {
    switch (error.type) {
      case RegisterErrorType.validation:
        return error.serverMessage ?? l10n.registerErrorValidation;
      case RegisterErrorType.conflict:
        return error.serverMessage ?? l10n.registerErrorConflict;
      case RegisterErrorType.server:
        return l10n.registerErrorServer;
      case RegisterErrorType.timeout:
        return l10n.registerErrorTimeout;
      case RegisterErrorType.connection:
        return l10n.registerErrorConnection;
      case RegisterErrorType.badResponse:
        return l10n.registerErrorBadResponse;
      case RegisterErrorType.unknown:
        return l10n.registerErrorUnexpected;
    }
  }

  void setLoading(bool value) {
    if (_isLoading == value) return;
    _isLoading = value;
    notifyListeners();
  }

  void setError(String? value) {
    if (_errorMessage == value) return;
    _errorMessage = value;
    notifyListeners();
  }
}
