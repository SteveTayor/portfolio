import 'package:flutter/material.dart';

/// A botanical-velvet colour system with a deliberate rhythm between sections.
///
/// Emerald is the functional accent. Wine, rose, beige and mauve create the
/// atmosphere through low-opacity washes and blended section surfaces. They
/// should not become five competing button or label colours.
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
    required this.emerald,
    required this.wine,
    required this.rose,
    required this.beige,
    required this.mauve,
    required this.hotBlood,
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

  /// Atmospheric colours used for blended section backgrounds and imagery.
  final Color emerald;
  final Color wine;
  final Color rose;
  final Color beige;
  final Color mauve;

  /// A restrained, higher-energy red. Reserve it for rare micro-details.
  final Color hotBlood;

  bool get isDark => brightness == Brightness.dark;

  // Backwards-compatible names for widgets that still use the earlier API.
  Color get atmosphereTeal => emerald;
  Color get atmosphereWine => wine;
  Color get atmosphereRose => rose;
  Color get atmosphereBlue => beige;
  Color get atmosphereMauve => mauve;

  /// Device materials, shared by both themes.
  static const Color silver = Color(0xFFC8CBC2);
  static const Color silverEdge = Color(0xFF9DA298);
  static const Color bezel = Color(0xFF0A0C0A);

  /// Dark mode: blackened plum, warm ivory, botanical green and velvet wine.
  static const Palette dark = Palette(
    brightness: Brightness.dark,
    bg: Color(0xFF160D13),
    surface: Color(0xFF211820),
    raised: Color(0xFF2D2029),
    text: Color(0xFFF4ECE4),
    text2: Color(0xFFD1C1C7),
    muted: Color(0xFFAA96A1),
    accent: Color(0xFF83C69D),
    onAccent: Color(0xFF10241A),
    border: Color(0xFF473741),
    emerald: Color(0xFF347A5B),
    wine: Color(0xFF8F425B),
    rose: Color(0xFFB87990),
    beige: Color(0xFFB49A7D),
    mauve: Color(0xFF806A82),
    hotBlood: Color(0xFFCF5362),
  );

  /// Light mode: soft beige paper, deep wine-tinted ink and living green.
  static const Palette light = Palette(
    brightness: Brightness.light,
    bg: Color(0xFFF6F0E8),
    surface: Color(0xFFEDE1D7),
    raised: Color(0xFFFCF8F2),
    text: Color(0xFF30202A),
    text2: Color(0xFF594650),
    muted: Color(0xFF725D66),
    accent: Color(0xFF246548),
    onAccent: Color(0xFFFCF8F2),
    border: Color(0xFFDBCBC4),
    emerald: Color(0xFF82B697),
    wine: Color(0xFF8A3D55),
    rose: Color(0xFFD8A8B8),
    beige: Color(0xFFD9C0A1),
    mauve: Color(0xFFB7A3B9),
    hotBlood: Color(0xFFA92F45),
  );

  static Palette of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? dark : light;
}
