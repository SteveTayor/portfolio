import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'palette.dart';

/// A quieter, more compact type system: Manrope for headings and Inter for
/// readable body copy, labels and controls.
abstract final class Typo {
  /// Reduce large display text consistently across every section. The cap also
  /// prevents decorative footer text from overpowering the actual content.
  static double _displaySize(double size) =>
      (size * 0.74).clamp(0.0, 64.0).toDouble();

  static TextStyle display(
    Palette p,
    double size, {
    Color? color,
    double height = 1.08,
    FontStyle style = FontStyle.normal,
    FontWeight weight = FontWeight.w600,
  }) {
    final visualSize = _displaySize(size);
    return GoogleFonts.manrope(
      fontSize: visualSize,
      height: height,
      color: color ?? p.text,
      fontWeight: weight,
      letterSpacing: -visualSize * 0.018,
      fontStyle: style,
    );
  }

  static TextStyle body(
    Palette p, {
    double size = 17,
    Color? color,
    double height = 1.48,
    FontWeight weight = FontWeight.w400,
  }) {
    return GoogleFonts.inter(
      fontSize: size * 0.92,
      height: height,
      color: color ?? p.text2,
      fontWeight: weight,
    );
  }

  static TextStyle label(Palette p, {Color? color, double size = 13}) {
    return GoogleFonts.inter(
      fontSize: size * 0.92,
      height: 1.35,
      color: color ?? p.muted,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.12,
    );
  }
}
