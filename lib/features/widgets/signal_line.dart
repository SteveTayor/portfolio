import 'package:flutter/material.dart';
import '../../../../core/animation/signal_controller.dart';

/// The fine editorial line that connects section anchors down the page.
/// Painted in a fixed side gutter; nodes brighten as the bird passes them.
class SignalLine extends StatelessWidget {
  final SignalController controller;
  final Color lineColor;
  final Color activeColor;
  final double viewportHeight;

  const SignalLine({
    super.key,
    required this.controller,
    required this.lineColor,
    required this.activeColor,
    required this.viewportHeight,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return CustomPaint(
            size: Size(24, viewportHeight),
            painter: _SignalLinePainter(
              anchors: controller.anchors,
              scrollOffset: controller.scrollOffset,
              viewportHeight: viewportHeight,
              lineColor: lineColor,
              activeColor: activeColor,
            ),
          );
        },
      ),
    );
  }
}

class _SignalLinePainter extends CustomPainter {
  final List<double> anchors;
  final double scrollOffset;
  final double viewportHeight;
  final Color lineColor;
  final Color activeColor;

  _SignalLinePainter({
    required this.anchors,
    required this.scrollOffset,
    required this.viewportHeight,
    required this.lineColor,
    required this.activeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;

    if (anchors.length < 2) {
      // Before anchors are measured: subdued full-height line.
      canvas.drawLine(
        Offset(cx, 0),
        Offset(cx, viewportHeight),
        Paint()
          ..color = lineColor
          ..strokeWidth = 1,
      );
      return;
    }

    // Line segments between consecutive anchor screen positions.
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 1;
    final activePaint = Paint()
      ..color = activeColor
      ..strokeWidth = 1.2;

    for (var i = 0; i < anchors.length - 1; i++) {
      final y1 = anchors[i] - scrollOffset;
      final y2 = anchors[i + 1] - scrollOffset;
      // Only draw segments intersecting the viewport.
      if (y2 < -40 || y1 > viewportHeight + 40) continue;
      final passed = anchors[i] <= scrollOffset + viewportHeight * 0.45;
      canvas.drawLine(
        Offset(cx, y1.clamp(-40.0, viewportHeight + 40.0)),
        Offset(cx, y2.clamp(-40.0, viewportHeight + 40.0)),
        passed ? activePaint : paint,
      );
    }

    // Connection nodes at each anchor.
    final nodePaint = Paint()..style = PaintingStyle.fill;
    for (final a in anchors) {
      final y = a - scrollOffset;
      if (y < -10 || y > viewportHeight + 10) continue;
      final passed = a <= scrollOffset + viewportHeight * 0.45;
      nodePaint.color = passed ? activeColor : lineColor;
      canvas.drawCircle(Offset(cx, y), passed ? 3 : 2, nodePaint);
    }
  }

  @override
  bool shouldRepaint(_SignalLinePainter old) =>
      old.scrollOffset != scrollOffset ||
      old.viewportHeight != viewportHeight ||
      old.lineColor != lineColor ||
      old.activeColor != activeColor ||
      old.anchors.length != anchors.length;
}
