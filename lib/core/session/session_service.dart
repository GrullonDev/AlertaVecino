import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:neighbour_alert/features/auth/login/model/user.dart';

class SessionService extends ChangeNotifier {
  SessionService({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _tokenKey = 'jwt_token';
  static const _userIdKey = 'user_id';
  static const _userEmailKey = 'user_email';
  static const _userResidencyKey = 'user_residency';
  static const _userHouseKey = 'user_house';
  static const _userFirstNameKey = 'user_first_name';
  static const _userLastNameKey = 'user_last_name';
  static const _userPhoneKey = 'user_phone';

  String? _token;
  User? _user;

  String? get token => _token;
  User? get user => _user;
  bool get isAuthenticated => _token != null;

  Future<void> saveSession({required String token, required User user}) async {
    _token = token;
    _user = user;

    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(key: _userIdKey, value: user.id);
    await _storage.write(key: _userEmailKey, value: user.email);
    if (user.residency != null) {
      await _storage.write(key: _userResidencyKey, value: user.residency);
    }
    if (user.house != null) {
      await _storage.write(key: _userHouseKey, value: user.house);
    }

    notifyListeners();
  }

  Future<void> updateUserDetails({
    String? firstName,
    String? lastName,
    String? phone,
    String? residency,
    String? house,
  }) async {
    if (firstName != null) {
      await _storage.write(key: _userFirstNameKey, value: firstName);
    }
    if (lastName != null) {
      await _storage.write(key: _userLastNameKey, value: lastName);
    }
    if (phone != null) {
      await _storage.write(key: _userPhoneKey, value: phone);
    }
    if (residency != null) {
      await _storage.write(key: _userResidencyKey, value: residency);
    }
    if (house != null) {
      await _storage.write(key: _userHouseKey, value: house);
    }

    _user = User(
      id: _user?.id ?? '',
      email: _user?.email ?? '',
      residency: residency ?? _user?.residency,
      house: house ?? _user?.house,
    );
    notifyListeners();
  }

  Future<bool> tryRestoreSession() async {
    try {
      final token = await _storage.read(key: _tokenKey);
      if (token == null) return false;

      final id = await _storage.read(key: _userIdKey) ?? '';
      final email = await _storage.read(key: _userEmailKey) ?? '';
      final residency = await _storage.read(key: _userResidencyKey);
      final house = await _storage.read(key: _userHouseKey);

      _token = token;
      _user = User(id: id, email: email, residency: residency, house: house);
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> clearSession() async {
    _token = null;
    _user = null;
    await _storage.deleteAll();
    notifyListeners();
  }
}
