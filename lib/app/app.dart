import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_theme.dart';
import '../core/theme/palette.dart';
import '../core/theme/theme_controller.dart';
import 'router.dart';

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({super.key, required this.theme});

  final ThemeController theme;

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  // Created exactly once. Rebuilding the router on every theme change is what
  // caused the framework assertion in the previous version.
  late final GoRouter _router = buildRouter();

  static final ThemeData _light = AppTheme.build(Palette.light);
  static final ThemeData _dark = AppTheme.build(Palette.dark);

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeScope(
      controller: widget.theme,
      child: ListenableBuilder(
        listenable: widget.theme,
        builder: (context, _) {
          return MaterialApp.router(
            title: 'Ayomide Arowolo, Flutter Developer',
            debugShowCheckedModeBanner: false,
            theme: _light,
            darkTheme: _dark,
            themeMode: widget.theme.mode,
            routerConfig: _router,
          );
        },
      ),
    );
  }
}
