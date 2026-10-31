import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:neighbour_alert/core/session/session_service.dart';
import 'package:neighbour_alert/features/admin/login/logic/admin_login_logic.dart';
import 'package:neighbour_alert/features/admin/login/pages/admin_login_layout.dart';
import 'package:neighbour_alert/features/auth/login/data/repository.dart';
import 'package:neighbour_alert/utils/injection_container.dart';

class AdminLoginPage extends StatelessWidget {
  const AdminLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminLoginLogic(
        repository: sl<Repository>(),
        sessionService: sl<SessionService>(),
      ),
      child: const Scaffold(body: AdminLoginLayout()),
    );
  }
}
