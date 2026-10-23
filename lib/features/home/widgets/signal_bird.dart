import 'package:flutter/material.dart';

import '../../../core/theme/palette.dart';

/// A fine signal line along the page edge with a small bird that travels down
/// it as the visitor scrolls. Decoration only: it never takes input.
class SignalBird extends StatelessWidget {
  const SignalBird({super.key, required this.scroll, required this.start});

  final ScrollController scroll;
  final double start; // scroll offset where the intro ends

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final reduced = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    return AnimatedBuilder(
      animation: scroll,
      builder: (context, _) {
        if (!scroll.hasClients) return const SizedBox.shrink();
        final pos = scroll.position;
        final off = pos.pixels;
        final span = pos.maxScrollExtent - start;
        final t = span <= 0 ? 0.0 : ((off - start) / span).clamp(0.0, 1.0);
        final vis = ((off - start * 0.9) / 220).clamp(0.0, 1.0).toDouble();
        if (vis <= 0) return const SizedBox.shrink();
        return IgnorePointer(
          child: Opacity(
            opacity: vis,
            child: CustomPaint(
              size: Size.infinite,
              painter: _SignalPainter(
                progress: reduced ? 1.0 : t.toDouble(),
                line: p.border,
                active: p.accent,
                bird: p.text2,
                fill: p.bg,
                showBird: !reduced,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SignalPainter extends CustomPainter {
  const _SignalPainter({
    required this.progress,
    required this.line,
    required this.active,
    required this.bird,
    required this.fill,
    required this.showBird,
  });

  final double progress;
  final Color line;
  final Color active;
  final Color bird;
  final Color fill;
  final bool showBird;

  @override
  void paint(Canvas canvas, Size size) {
    final x = size.width - (size.width < 720 ? 12.0 : 30.0);
    final top = 96.0;
    final bottom = size.height - 48.0;
    final y = top + (bottom - top) * progress;

    canvas.drawLine(
      Offset(x, top),
      Offset(x, bottom),
      Paint()
        ..color = line
        ..strokeWidth = 1,
    );
    canvas.drawLine(
      Offset(x, top),
      Offset(x, y),
      Paint()
        ..color = active
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(Offset(x, y), 3.5, Paint()..color = active);

    if (!showBird) return;
    canvas.save();
    canvas.translate(x - 44, y - 22);
    final path = Path()
      ..moveTo(0, 9)
      ..cubicTo(6, 2, 12, 2, 16, 8)
      ..cubicTo(19, 3, 25, 2, 30, 5)
      ..lineTo(34, 6)
      ..lineTo(29, 8)
      ..cubicTo(27, 13, 20, 17, 12, 16)
      ..cubicTo(8, 16, 3, 14, 0, 9)
      ..close();
    canvas.drawPath(path, Paint()..color = fill);
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..strokeJoin = StrokeJoin.round
        ..color = bird,
    );
    final wing = Path()
      ..moveTo(10, 9)
      ..cubicTo(15, 12, 20, 12, 24, 8);
    canvas.drawPath(
      wing,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..strokeCap = StrokeCap.round
        ..color = bird,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SignalPainter old) =>
      old.progress != progress ||
      old.line != line ||
      old.active != active ||
      old.showBird != showBird;
}
