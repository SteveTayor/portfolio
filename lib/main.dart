import 'package:flutter/material.dart';

import 'app/app.dart';
import 'core/theme/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final theme = ThemeController();
  await theme.load(); // never throws, falls back to the system theme
  runApp(PortfolioApp(theme: theme));
}
