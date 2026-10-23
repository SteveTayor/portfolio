import 'package:flutter/material.dart';

/// One shared set of colour roles. Nature and Apple inspired: warm graphite,
/// bone, stone and moss. No navy, no blue, no gold.
@immutable
class Palette {
  const Palette({
    required this.brightness,
    required this.bg,
    required this.surface,
    required this.raised,
    required this.text,
    required this.text2,
    required this.muted,
    required this.accent,
    required this.onAccent,
    required this.border,
  });

  final Brightness brightness;
  final Color bg;
  final Color surface;
  final Color raised;
  final Color text;
  final Color text2;
  final Color muted;
  final Color accent;
  final Color onAccent;
  final Color border;

  bool get isDark => brightness == Brightness.dark;

  /// Device materials, shared by both themes.
  static const Color silver = Color(0xFFC8CBC2);
  static const Color silverEdge = Color(0xFF9DA298);
  static const Color bezel = Color(0xFF0A0C0A);

  static const Palette dark = Palette(
    brightness: Brightness.dark,
    bg: Color(0xFF0F1210),
    surface: Color(0xFF151A16),
    raised: Color(0xFF1C221D),
    text: Color(0xFFEDEFE7),
    text2: Color(0xFFA9B1A4),
    muted: Color(0xFF7F887B),
    accent: Color(0xFFA3B993),
    onAccent: Color(0xFF0F1210),
    border: Color(0xFF2B322C),
  );

  static const Palette light = Palette(
    brightness: Brightness.light,
    bg: Color(0xFFEFEEE7),
    surface: Color(0xFFE5E4DB),
    raised: Color(0xFFF7F6F1),
    text: Color(0xFF171A16),
    text2: Color(0xFF545B50),
    muted: Color(0xFF626A5E),
    accent: Color(0xFF486641),
    onAccent: Color(0xFFF7F6F1),
    border: Color(0xFFD3D2C7),
  );

  static Palette of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? dark : light;
}
