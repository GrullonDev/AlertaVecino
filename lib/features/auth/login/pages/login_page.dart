import 'package:flutter/material.dart';
import 'package:neighbour_alert/features/auth/login/pages/login_layout.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: LoginLayout()));
  }
}
