import 'package:neighbour_alert/features/auth/login/model/user.dart';

class LoginResponse {
  LoginResponse({
    required this.message,
    required this.token,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'] as String? ?? '',
      token: json['token'] as String? ?? '',
      user: json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : User(email: '', residency: '', house: ''),
    );
  }

  final String message;
  final String token;
  final User user;

  bool get isValid => token.isNotEmpty;
}
