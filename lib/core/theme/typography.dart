import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'palette.dart';

/// Instrument Serif for display type, Inter for everything else.
abstract final class Typo {
  static TextStyle display(
    Palette p,
    double size, {
    Color? color,
    double height = 1.04,
    FontStyle style = FontStyle.normal,
  }) {
    return GoogleFonts.instrumentSerif(
      fontSize: size,
      height: height,
      color: color ?? p.text,
      letterSpacing: -size * 0.012,
      fontStyle: style,
    );
  }

  static TextStyle body(
    Palette p, {
    double size = 17,
    Color? color,
    double height = 1.65,
    FontWeight weight = FontWeight.w400,
  }) {
    return GoogleFonts.inter(
      fontSize: size,
      height: height,
      color: color ?? p.text2,
      fontWeight: weight,
    );
  }

  static TextStyle label(Palette p, {Color? color, double size = 13}) {
    return GoogleFonts.inter(
      fontSize: size,
      height: 1.3,
      color: color ?? p.muted,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.3,
    );
  }
}
