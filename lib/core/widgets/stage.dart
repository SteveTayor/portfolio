import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../theme/palette.dart';

/// A dark block with a rounded top edge. It stays dark in both themes, like a
/// room with the lights low, and everything inside reads the dark palette.
class StageBlock extends StatelessWidget {
  const StageBlock({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.stage,
      child: Builder(
        builder: (context) {
          final p = Palette.of(context);
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  p.bg,
                  Color.lerp(p.bg, p.atmosphereTeal, 0.14)!,
                  Color.lerp(p.bg, p.atmosphereBlue, 0.10)!,
                  p.bg,
                ],
                stops: const [0.0, 0.28, 0.68, 1.0],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(56),
              ),
            ),
            child: child,
          );
        },
      ),
    );
  }
}
