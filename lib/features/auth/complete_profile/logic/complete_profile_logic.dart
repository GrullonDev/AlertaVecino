import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:neighbour_alert/features/auth/complete_profile/data/repository.dart';
import 'package:neighbour_alert/features/auth/complete_profile/model/complete_profile_error.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';

class CompleteProfileLogic extends ChangeNotifier {
  CompleteProfileLogic({required CompleteProfileRepository repository})
    : _repository = repository;

  final CompleteProfileRepository _repository;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  /// Envía la residencia y unidad elegidas. Devuelve `true` si fue exitoso.
  Future<bool> submit({
    required String token,
    required String userId,
    required String residency,
    required String house,
    required AppLocalizations l10n,
  }) async {
    setError(null);
    setLoading(true);

    try {
      await _repository.completeProfile(
        token: token,
        userId: userId,
        residency: residency,
        house: house,
      );
      setLoading(false);
      return true;
    } on CompleteProfileException catch (e) {
      dev.log('Complete-profile error: $e');
      setLoading(false);
      setError(_messageFor(e, l10n));
      return false;
    } catch (e) {
      dev.log('Complete-profile error inesperado: $e');
      setLoading(false);
      setError(l10n.completeProfileErrorUnexpected);
      return false;
    }
  }

  String _messageFor(CompleteProfileException error, AppLocalizations l10n) {
    switch (error.type) {
      case CompleteProfileErrorType.validation:
        return error.serverMessage ?? l10n.completeProfileErrorValidation;
      case CompleteProfileErrorType.unauthorized:
        return l10n.completeProfileErrorUnauthorized;
      case CompleteProfileErrorType.notFound:
        return l10n.completeProfileErrorUnauthorized;
      case CompleteProfileErrorType.server:
        return l10n.completeProfileErrorServer;
      case CompleteProfileErrorType.timeout:
        return l10n.completeProfileErrorTimeout;
      case CompleteProfileErrorType.connection:
        return l10n.completeProfileErrorConnection;
      case CompleteProfileErrorType.badResponse:
        return l10n.completeProfileErrorBadResponse;
      case CompleteProfileErrorType.unknown:
        return l10n.completeProfileErrorUnexpected;
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
