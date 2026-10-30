import 'package:flutter/material.dart';
import 'core/settings/app_settings.dart';
import 'darsak_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSettings.instance.load();
  runApp(const DarsakApp());
}