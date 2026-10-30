// import 'package:flutter/material.dart';

// /// Shared colour roles for a warm, nature-led palette with a little more life.
// /// Atmospheric colours are used in low-opacity washes, not as competing accents.
// @immutable
// class Palette {
//   const Palette({
//     required this.brightness,
//     required this.bg,
//     required this.surface,
//     required this.raised,
//     required this.text,
//     required this.text2,
//     required this.muted,
//     required this.accent,
//     required this.onAccent,
//     required this.border,
//     required this.atmosphereTeal,
//     required this.atmosphereBlue,
//     required this.atmosphereRose,
//   });

//   final Brightness brightness;
//   final Color bg;
//   final Color surface;
//   final Color raised;
//   final Color text;
//   final Color text2;
//   final Color muted;
//   final Color accent;
//   final Color onAccent;
//   final Color border;

//   /// Secondary tones for soft gradients and image transitions. Keep these
//   /// atmospheric rather than using them for labels or primary actions.
//   final Color atmosphereTeal;
//   final Color atmosphereBlue;
//   final Color atmosphereRose;

//   bool get isDark => brightness == Brightness.dark;

//   /// Device materials, shared by both themes.
//   static const Color silver = Color(0xFFC8CBC2);
//   static const Color silverEdge = Color(0xFF9DA298);
//   static const Color bezel = Color(0xFF0A0C0A);

//   static const Palette dark = Palette(
//     brightness: Brightness.dark,
//     bg: Color(0xFF0F1210),
//     surface: Color(0xFF151A16),
//     raised: Color(0xFF1C221D),
//     text: Color(0xFFEDEFE7),
//     text2: Color(0xFFA9B1A4),
//     muted: Color(0xFF7F887B),
//     accent: Color(0xFFA3B993),
//     onAccent: Color(0xFF0F1210),
//     border: Color(0xFF2B322C),
//     atmosphereTeal: Color(0xFF28554F),
//     atmosphereBlue: Color(0xFF31495D),
//     atmosphereRose: Color(0xFF513C48),
//   );

//   static const Palette light = Palette(
//     brightness: Brightness.light,
//     bg: Color(0xFFEFEEE7),
//     surface: Color(0xFFE5E4DB),
//     raised: Color(0xFFF7F6F1),
//     text: Color(0xFF171A16),
//     text2: Color(0xFF545B50),
//     muted: Color(0xFF626A5E),
//     accent: Color(0xFF486641),
//     onAccent: Color(0xFFF7F6F1),
//     border: Color(0xFFD3D2C7),
//     atmosphereTeal: Color(0xFF9ECBC0),
//     atmosphereBlue: Color(0xFFB5CADD),
//     atmosphereRose: Color(0xFFDCC2CB),
//   );

//   static Palette of(BuildContext context) =>
//       Theme.of(context).brightness == Brightness.dark ? dark : light;
// }

import 'package:flutter/material.dart';

/// Shared colour roles: a velvet room by night, a soft beige room by day.
///
/// Deep wine and oxblood carry the dark theme, warm beige carries the light
/// one, and emerald is the one living accent in both. Hot blood is a small,
/// rare spark. Rose, mauve and emerald washes give atmosphere at low opacity
/// and are never used for labels or primary actions.
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
    required this.hot,
    required this.wine,
    required this.rose,
    required this.mauve,
    required this.emerald,
  });

  final Brightness brightness;
  final Color bg;
  final Color surface;
  final Color raised;
  final Color text;
  final Color text2;
  final Color muted;
  final Color border;

  /// The main accent: emerald. Primary buttons, active states, links.
  final Color accent;
  final Color onAccent;

  /// Hot blood. Large display words, a focus ring or one small marker, never
  /// body text (it reaches about 4 to 1 on the dark theme).
  final Color hot;

  /// Washes for gradients, image transitions and quiet bands. Use at low
  /// opacity, for atmosphere only.
  final Color wine;
  final Color rose;
  final Color mauve;
  final Color emerald;

  bool get isDark => brightness == Brightness.dark;

  /// Kept so existing code that reads the old names keeps working.
  Color get atmosphereTeal => emerald;
  Color get atmosphereBlue => mauve;
  Color get atmosphereRose => rose;

  /// Device materials, shared by both themes.
  static const Color silver = Color(0xFFC8CBC2);
  static const Color silverEdge = Color(0xFF9DA298);
  static const Color bezel = Color(0xFF0A0C0A);

  /// Velvet.
  static const Palette dark = Palette(
    brightness: Brightness.dark,
    bg: Color(0xFF150A0F), // oxblood black
    surface: Color(0xFF1E0F15), // velvet
    raised: Color(0xFF2A1520), // deep wine
    border: Color(0xFF3B2029),
    text: Color(0xFFF2E9DF), // soft beige
    text2: Color(0xFFCDB9B4), // rose beige
    muted: Color(0xFFA08A93), // dusty mauve
    accent: Color(0xFF3DBE8B), // emerald
    onAccent: Color(0xFF08150F),
    hot: Color(0xFFD1344F), // hot blood
    wine: Color(0xFF4A1322), // burgundy
    rose: Color(0xFF6A3040), // dried rose
    mauve: Color(0xFF5E4254),
    emerald: Color(0xFF0E4A39),
  );

  /// Soft beige.
  static const Palette light = Palette(
    brightness: Brightness.light,
    bg: Color(0xFFF4ECE2), // soft beige
    surface: Color(0xFFEBDFD2), // sand
    raised: Color(0xFFFBF7F1), // ivory
    border: Color(0xFFDCCBBD),
    text: Color(0xFF2B1218), // deep wine
    text2: Color(0xFF5F474C),
    muted: Color(0xFF765D63), // dusty mauve
    accent: Color(0xFF0F6A4A), // emerald
    onAccent: Color(0xFFFBF7F1),
    hot: Color(0xFFA3182E), // hot blood
    wine: Color(0xFF6E1A2F), // burgundy
    rose: Color(0xFFE7C6CB), // pale rose
    mauve: Color(0xFFC9AEBB),
    emerald: Color(0xFFA9D3C0),
  );

  static Palette of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? dark : light;
}
