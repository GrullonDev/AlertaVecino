import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:neighbour_alert/config/app_theme.dart';
import 'package:neighbour_alert/core/session/session_service.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';
import 'package:neighbour_alert/utils/injection_container.dart';
import 'package:neighbour_alert/utils/router/route_path.dart';
import 'package:neighbour_alert/utils/router/route_switch.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SessionService>.value(
      value: sl<SessionService>(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Alerta Vecinos',
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        onGenerateRoute: RouteSwitch.onGenerateRoute,
        initialRoute: RoutePath.login,
      ),
    );
  }
}
