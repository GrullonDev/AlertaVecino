import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:neighbour_alert/utils/app.dart';
import 'package:neighbour_alert/utils/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  await init();

  runApp(const MyApp());
}
