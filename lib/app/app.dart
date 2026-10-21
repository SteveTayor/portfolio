import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/theme_controller.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/colors.dart';
import 'router.dart';

/// App-lifetime theme controller, reachable from the navigation bar.
final ThemeController themeController = ThemeController();

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({super.key});

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  @override
  void initState() {
    super.initState();
    themeController.load();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeController,
      builder: (context, _) {
        return MaterialApp.router(
          title: 'Ayomide Arowolo — Flutter Developer',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.build(AppColors.light),
          darkTheme: AppTheme.build(AppColors.dark),
          themeMode: themeController.mode,
          routerConfig: buildRouter(),
        );
      },
    );
  }
}
