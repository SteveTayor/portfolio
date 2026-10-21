import 'package:flutter/material.dart';

/// Design tokens for both themes. [AppColors.of].
class AppColors {
  final Color bg;
  final Color bgSecondary;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color accentTeal;
  final Color accentBlue;
  final Color border;
  final Color success;
  final Color error;
  final Color focus;

  const AppColors({
    required this.bg,
    required this.bgSecondary,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.accentTeal,
    required this.accentBlue,
    required this.border,
    required this.success,
    required this.error,
    required this.focus,
  });

  static const AppColors dark = AppColors(
    bg: Color(0xFF0B1020),
    bgSecondary: Color(0xFF10182A),
    surface: Color(0xFF151F33),
    textPrimary: Color(0xFFF4F7FB),
    textSecondary: Color(0xFFA5B1C5),
    textMuted: Color(0xFF7F8BA1),
    accentTeal: Color(0xFF75D6C3),
    accentBlue: Color(0xFFA5BEFF),
    border: Color(0xFF29344A),
    success: Color(0xFF6FCF97),
    error: Color(0xFFEB6A6A),
    focus: Color(0xFFA5BEFF),
  );

  static const AppColors light = AppColors(
    bg: Color(0xFFF5F7FA),
    bgSecondary: Color(0xFFEDF1F6),
    surface: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF142033),
    textSecondary: Color(0xFF586579),
    textMuted: Color(0xFF758198),
    accentTeal: Color(0xFF147C73),
    accentBlue: Color(0xFF4567B8),
    border: Color(0xFFDCE3EC),
    success: Color(0xFF1E7F4F),
    error: Color(0xFFB33636),
    focus: Color(0xFF4567B8),
  );

  static AppColors of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? AppColors.dark
      : AppColors.light;
}
