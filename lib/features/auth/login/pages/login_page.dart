import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:neighbour_alert/features/auth/login/data/repository.dart';
import 'package:neighbour_alert/features/auth/login/logic/login_logic.dart';
import 'package:neighbour_alert/features/auth/login/pages/login_layout.dart';
import 'package:neighbour_alert/utils/injection_container.dart';
import 'package:neighbour_alert/utils/widgets/auth_scaffold.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginLogic>(
      create: (context) => LoginLogic(repository: sl.get<Repository>()),
      child: const AuthScaffold(child: LoginLayout()),
    );
  }
}
