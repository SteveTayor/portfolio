import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A small, minimal line-art bird. Editorial illustration, not a mascot:
/// clear silhouette, restrained colour, one subtle wing motion.
class TravellingBird extends StatefulWidget {
  final Color color;
  final double width;
  final bool reducedMotion;

  const TravellingBird({
    super.key,
    required this.color,
    this.width = 44,
    this.reducedMotion = false,
  });

  @override
  State<TravellingBird> createState() => _TravellingBirdState();
}

class _TravellingBirdState extends State<TravellingBird>
    with SingleTickerProviderStateMixin {
  late final AnimationController _flap;

  @override
  void initState() {
    super.initState();
    _flap = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    if (!widget.reducedMotion) _flap.repeat();
  }

  @override
  void dispose() {
    _flap.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.width * 0.62;
    return AnimatedBuilder(
      animation: _flap,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.width, height),
          painter: _BirdPainter(
            color: widget.color,
            wingPhase: widget.reducedMotion ? 0.6 : _flap.value * math.pi * 2,
          ),
        );
      },
    );
  }
}

class _BirdPainter extends CustomPainter {
  final Color color;
  final double wingPhase;

  _BirdPainter({required this.color, required this.wingPhase});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Body: a single confident curve from tail to head.
    final body = Path()
      ..moveTo(w * 0.10, h * 0.58)
      ..cubicTo(w * 0.14, h * 0.30, w * 0.42, h * 0.16, w * 0.66, h * 0.22)
      ..cubicTo(w * 0.86, h * 0.27, w * 0.94, h * 0.42, w * 0.88, h * 0.55)
      ..cubicTo(w * 0.78, h * 0.76, w * 0.44, h * 0.82, w * 0.24, h * 0.72)
      ..cubicTo(w * 0.14, h * 0.67, w * 0.08, h * 0.63, w * 0.10, h * 0.58);
    canvas.drawPath(body, stroke);

    // Beak.
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.88, h * 0.44)
        ..lineTo(w * 0.99, h * 0.40)
        ..lineTo(w * 0.90, h * 0.52),
      stroke,
    );

    // Eye: a single dot.
    canvas.drawCircle(
      Offset(w * 0.80, h * 0.36),
      1.5,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );

    // Wing: one flap, subtle amplitude.
    final lift = math.sin(wingPhase) * h * 0.10 + h * 0.04;
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.34, h * 0.56)
        ..quadraticBezierTo(
          w * 0.48,
          h * 0.26 - lift,
          w * 0.72,
          h * 0.40 - lift,
        ),
      stroke..strokeWidth = 1.3,
    );

    // Tail feathers.
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.12, h * 0.60)
        ..lineTo(w * 0.01, h * 0.52)
        ..moveTo(w * 0.12, h * 0.62)
        ..lineTo(w * 0.02, h * 0.62),
      stroke..strokeWidth = 1.2,
    );
  }

  @override
  bool shouldRepaint(_BirdPainter old) =>
      old.color != color || old.wingPhase != wingPhase;
}
