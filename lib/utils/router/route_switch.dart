import 'package:flutter/material.dart';
import 'package:neighbour_alert/features/alerts/pages/alerts_page.dart';
import 'package:neighbour_alert/features/auth/login/pages/login_page.dart';
import 'package:neighbour_alert/features/auth/pending_approval/pages/pending_approval_page.dart';
import 'package:neighbour_alert/features/auth/register/pages/register_page.dart';
import 'package:neighbour_alert/features/auth/select_residency/pages/select_residency_page.dart';
import 'package:neighbour_alert/features/home/pages/home_page.dart';
import 'package:neighbour_alert/features/panic/pages/panic_type_selection_page.dart';
import 'package:neighbour_alert/features/maps/pages/map_page.dart';
import 'package:neighbour_alert/features/profile/pages/profile_page.dart';
import 'package:neighbour_alert/utils/router/route_path.dart';
import 'package:neighbour_alert/utils/widgets/widget_not_found.dart';

class RouteSwitch {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePath.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case RoutePath.register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case RoutePath.selectResidency:
        return MaterialPageRoute(builder: (_) => const SelectResidencyPage());
      case RoutePath.pendingApproval:
        return MaterialPageRoute(builder: (_) => const PendingApprovalPage());
      case RoutePath.panic:
        return MaterialPageRoute(builder: (_) => const PanicTypeSelectionPage());
      case RoutePath.home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case RoutePath.incidentMap:
        return MaterialPageRoute(builder: (_) => const MapPage());
      case RoutePath.notifications:
        return MaterialPageRoute(builder: (_) => const AlertsPage());
      case RoutePath.profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
    }
    return MaterialPageRoute(builder: (_) => const WidgetNotFound());
  }
}
