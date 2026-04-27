import 'package:flutter/material.dart';
import 'package:neighbour_alert/utils/router/route_path.dart';
import 'package:neighbour_alert/utils/router/route_switch.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      onGenerateRoute: RouteSwitch.onGenerateRoute,
      initialRoute: RoutePath.login,
    );
  }
}
