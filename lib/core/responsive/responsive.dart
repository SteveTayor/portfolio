import 'package:flutter/widgets.dart';

enum AppBreakpoint { smallMobile, mobile, tablet, laptop, desktop }

/// Layout guides, not device assumptions. All values are width-based.
class Responsive {
  static AppBreakpoint of(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w < 375) return AppBreakpoint.smallMobile;
    if (w < 600) return AppBreakpoint.mobile;
    if (w < 900) return AppBreakpoint.tablet;
    if (w < 1200) return AppBreakpoint.laptop;
    return AppBreakpoint.desktop;
  }

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 600;

  static bool isCompact(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 900;

  /// Central content width with 24 px side gutters, capped at 1240 px.
  static double contentWidth(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width - 48;
    return w < 0 ? 0 : (w > 1240 ? 1240 : w);
  }

  /// Horizontal section padding: generous on desktop, tighter on mobile.
  static double sidePadding(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w >= 1200) return (w - 1240) / 2;
    return 24;
  }

  /// Vertical rhythm between sections.
  static double sectionSpacing(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w >= 1200) return 128;
    if (w >= 900) return 96;
    if (w >= 600) return 84;
    return 64;
  }
}
