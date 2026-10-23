import 'package:flutter/material.dart';

import 'palette.dart';

abstract final class AppTheme {
  static ThemeData build(Palette p) {
    final scheme = ColorScheme.fromSeed(
      seedColor: p.accent,
      brightness: p.brightness,
    ).copyWith(primary: p.accent, onPrimary: p.onAccent, surface: p.bg);
    return ThemeData(
      useMaterial3: true,
      brightness: p.brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: p.bg,
      canvasColor: p.bg,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: p.accent,
        selectionColor: p.accent.withAlpha(80),
      ),
    );
  }
}
