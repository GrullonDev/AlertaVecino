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
  static const _userRoleKey = 'user_role';

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
    if (user.firstName != null) {
      await _storage.write(key: _userFirstNameKey, value: user.firstName);
    }
    if (user.lastName != null) {
      await _storage.write(key: _userLastNameKey, value: user.lastName);
    }
    if (user.phone != null) {
      await _storage.write(key: _userPhoneKey, value: user.phone);
    }
    if (user.residency != null) {
      await _storage.write(key: _userResidencyKey, value: user.residency);
    }
    if (user.house != null) {
      await _storage.write(key: _userHouseKey, value: user.house);
    }
    if (user.role != null) {
      await _storage.write(key: _userRoleKey, value: user.role);
    }

    notifyListeners();
  }

  Future<void> updateUser(User user) async {
    _user = user;
    await _storage.write(key: _userIdKey, value: user.id);
    await _storage.write(key: _userEmailKey, value: user.email);
    await _writeOrDelete(_userFirstNameKey, user.firstName);
    await _writeOrDelete(_userLastNameKey, user.lastName);
    await _writeOrDelete(_userPhoneKey, user.phone);
    await _writeOrDelete(_userResidencyKey, user.residency);
    await _writeOrDelete(_userHouseKey, user.house);
    await _writeOrDelete(_userRoleKey, user.role);
    notifyListeners();
  }

  Future<bool> tryRestoreSession() async {
    try {
      final token = await _storage.read(key: _tokenKey);
      if (token == null) return false;

      final id = await _storage.read(key: _userIdKey) ?? '';
      final email = await _storage.read(key: _userEmailKey) ?? '';
      final firstName = await _storage.read(key: _userFirstNameKey);
      final lastName = await _storage.read(key: _userLastNameKey);
      final phone = await _storage.read(key: _userPhoneKey);
      final residency = await _storage.read(key: _userResidencyKey);
      final house = await _storage.read(key: _userHouseKey);
      final role = await _storage.read(key: _userRoleKey);

      _token = token;
      _user = User(
        id: id,
        email: email,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        residency: residency,
        house: house,
        role: role,
      );
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

  Future<void> _writeOrDelete(String key, String? value) async {
    if (value != null && value.isNotEmpty) {
      await _storage.write(key: key, value: value);
    } else {
      await _storage.delete(key: key);
    }
  }
}
