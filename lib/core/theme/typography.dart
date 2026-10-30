import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'palette.dart';

/// Manrope gives display text a confident, contemporary voice without the
/// advertising/editorial feel of a high-contrast display serif. Inter remains
/// the reading face for long-form copy and controls.
abstract final class Typo {
  /// Apply a consistent, deliberate reduction to the portfolio's type scale.
  /// Large display sizes are reduced more aggressively than small labels so
  /// hierarchy remains clear without oversized, advertising-like headlines.
  static double _displaySize(double size) =>
      (size * 0.84).clamp(0.0, 80.0).toDouble();

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
    double height = 1.45,
    FontWeight weight = FontWeight.w400,
  }) {
    return GoogleFonts.inter(
      // Body copy is reduced gently, keeping paragraphs comfortably readable.
      fontSize: size * 0.95,
      height: height,
      color: color ?? p.text2,
      fontWeight: weight,
    );
  }

  static TextStyle label(Palette p, {Color? color, double size = 13}) {
    return GoogleFonts.inter(
      fontSize: size * 0.96,
      height: 1.35,
      color: color ?? p.muted,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
    );
  }
}
