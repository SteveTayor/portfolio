import 'package:flutter/material.dart';

/// Breakpoints are always read from layout constraints, never from the window,
/// so the same widgets work inside the laptop screen and on the real page.
abstract final class Bp {
  static const double mobile = 720;
  static const double tablet = 1080;
  static const double maxContent = 1320;

  static double pad(double width) {
    if (width < mobile) return 22;
    if (width < tablet) return 40;
    return 72;
  }
}

class Frame extends StatelessWidget {
  const Frame({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Bp.maxContent),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Bp.pad(constraints.maxWidth),
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
