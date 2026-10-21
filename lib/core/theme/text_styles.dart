import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/responsive/responsive.dart';

/// Typography scale. Manrope for headings, Inter for body and metadata.
/// All sizes are fluid and derived from viewport width.
class AppTextStyles {
  static TextStyle hero(BuildContext context, Color color) {
    final size = (MediaQuery.sizeOf(context).width * 0.052).clamp(32.0, 66.0);
    return GoogleFonts.manrope(
      fontSize: size,
      fontWeight: FontWeight.w700,
      height: 1.12,
      letterSpacing: -1.2,
      color: color,
    );
  }

  static TextStyle sectionTitle(BuildContext context, Color color) {
    final size = (MediaQuery.sizeOf(context).width * 0.03).clamp(26.0, 44.0);
    return GoogleFonts.manrope(
      fontSize: size,
      fontWeight: FontWeight.w700,
      height: 1.15,
      letterSpacing: -0.8,
      color: color,
    );
  }

  static TextStyle projectTitle(BuildContext context, Color color) {
    final size = (MediaQuery.sizeOf(context).width * 0.022).clamp(22.0, 34.0);
    return GoogleFonts.manrope(
      fontSize: size,
      fontWeight: FontWeight.w700,
      height: 1.2,
      letterSpacing: -0.5,
      color: color,
    );
  }

  static TextStyle body(BuildContext context, Color color) => GoogleFonts.inter(
    fontSize: Responsive.isMobile(context) ? 15.5 : 17,
    fontWeight: FontWeight.w400,
    height: 1.65,
    color: color,
  );

  static TextStyle eyebrow(Color color) => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 2.4,
    color: color,
  );

  static TextStyle meta(Color color) => GoogleFonts.inter(
    fontSize: 12.5,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.4,
    color: color,
  );

  static TextStyle button(Color color) => GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: color,
  );

  static TextStyle nav(Color color) => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: color,
  );

  static TextStyle projectNumber(Color color) => GoogleFonts.manrope(
    fontSize: 64,
    fontWeight: FontWeight.w800,
    height: 1,
    letterSpacing: -2,
    color: color,
  );
}
