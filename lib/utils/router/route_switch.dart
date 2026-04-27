import 'package:flutter/material.dart';
import 'package:neighbour_alert/features/auth/login/pages/login_page.dart';
import 'package:neighbour_alert/features/auth/register/pages/register_page.dart';
import 'package:neighbour_alert/utils/router/route_path.dart';
import 'package:neighbour_alert/utils/widgets/widget_not_found.dart';

class RouteSwitch {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePath.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case RoutePath.register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
    }
    return MaterialPageRoute(builder: (_) => const WidgetNotFound());
  }
}
