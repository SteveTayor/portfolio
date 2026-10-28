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
              color: p.bg,
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
