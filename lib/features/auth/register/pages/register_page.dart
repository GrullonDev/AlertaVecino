import 'package:flutter/material.dart';
import 'package:neighbour_alert/features/auth/register/pages/register_layout.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SafeArea(child: RegisterLayout()));
  }
}
