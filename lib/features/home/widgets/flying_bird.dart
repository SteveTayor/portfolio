import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/palette.dart';

/// A bird that leaves the hero and flies a looping path across the whole page
/// as the visitor scrolls. Wings beat while the page moves and settle into a
/// glide when it stops. Decoration only: it never takes input.
class FlyingBird extends StatefulWidget {
  const FlyingBird({super.key, required this.scroll, required this.start});

  final ScrollController scroll;
  final double start; // scroll offset where the intro ends

  @override
  State<FlyingBird> createState() => _FlyingBirdState();
}

class _FlyingBirdState extends State<FlyingBird>
    with SingleTickerProviderStateMixin {
  late final AnimationController _flap = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 560),
  );
  Timer? _idle;
  bool _reduced = false;

  @override
  void initState() {
    super.initState();
    widget.scroll.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduced = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
  }

  void _onScroll() {
    if (_reduced) return;
    _flap.repeat();
    _idle?.cancel();
    _idle = Timer(const Duration(milliseconds: 600), () {
      if (mounted) _flap.forward(); // finish the stroke, then glide
    });
  }

  @override
  void dispose() {
    _idle?.cancel();
    widget.scroll.removeListener(_onScroll);
    _flap.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_reduced) return const SizedBox.shrink();
    final p = Palette.of(context);
    return AnimatedBuilder(
      animation: Listenable.merge([widget.scroll, _flap]),
      builder: (context, _) {
        final sc = widget.scroll;
        // The position exists before the first layout; its extents do not.
        if (!sc.hasClients || !sc.position.hasContentDimensions) {
          return const SizedBox.shrink();
        }
        final off = sc.position.pixels;
        final from = widget.start * 0.85;
        final span = sc.position.maxScrollExtent - from;
        if (span <= 0) return const SizedBox.shrink();
        final t = ((off - from) / span).clamp(0.0, 1.0).toDouble();
        return IgnorePointer(
          child: CustomPaint(
            size: Size.infinite,
            painter: _BirdPainter(
              t: t,
              phase: _flap.value * math.pi * 2,
              accent: p.accent,
              ink: p.text2,
              dark: p.isDark,
            ),
          ),
        );
      },
    );
  }
}

class _BirdPainter extends CustomPainter {
  const _BirdPainter({
    required this.t,
    required this.phase,
    required this.accent,
    required this.ink,
    required this.dark,
  });

  final double t;
  final double phase;
  final Color accent;
  final Color ink;
  final bool dark;

  // Waypoints in screen fractions. The bird enters from the right, banks
  // across the page, and ends low, near the footer.
  static const List<Offset> _pts = [
    Offset(1.25, 0.20),
    Offset(0.80, 0.30),
    Offset(0.42, 0.46),
    Offset(0.16, 0.34),
    Offset(0.50, 0.20),
    Offset(0.86, 0.50),
    Offset(0.60, 0.72),
    Offset(0.20, 0.62),
    Offset(0.14, 0.38),
    Offset(0.52, 0.28),
    Offset(0.88, 0.56),
    Offset(0.62, 0.76),
    Offset(0.30, 0.72),
    Offset(0.50, 0.84),
  ];

  static Offset _at(double v) {
    final n = _pts.length - 1;
    final f = v.clamp(0.0, 1.0) * n;
    final i = math.min(math.max(f.floor(), 0), n - 1);
    final u = f - i;
    final p0 = _pts[math.max(i - 1, 0)];
    final p1 = _pts[i];
    final p2 = _pts[i + 1];
    final p3 = _pts[math.min(i + 2, n)];
    return (p1 * 2 +
            (p2 - p0) * u +
            (p0 * 2 - p1 * 5 + p2 * 4 - p3) * (u * u) +
            (p1 * 3 - p0 - p2 * 3 + p3) * (u * u * u)) *
        0.5;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Offset px(double v) {
      final n = _at(v);
      return Offset(n.dx * size.width, n.dy * size.height);
    }

    final pos = px(t);
    final ahead = px((t + 0.004).clamp(0.0, 1.0)) - px((t - 0.004).clamp(0.0, 1.0));
    final heading = math.atan2(ahead.dy, ahead.dx);
    final unit =
        (math.min(size.width, size.height) * 0.17).clamp(64.0, 150.0).toDouble();
    final depth = 0.88 + 0.22 * math.sin(t * math.pi * 6);
    final fade = (t * 18).clamp(0.0, 1.0).toDouble();

    // A faint trail along the path just flown.
    final trail = 36;
    for (var i = 0; i < trail; i++) {
      final a = t - 0.20 * (i / trail);
      final b = t - 0.20 * ((i + 1) / trail);
      if (b < 0) break;
      canvas.drawLine(
        px(a),
        px(b),
        Paint()
          ..color = accent.withAlpha(((1 - i / trail) * 70 * fade).round())
          ..strokeWidth = 1.2
          ..strokeCap = StrokeCap.round,
      );
    }

    // Soft ghosts behind the bird give a sense of speed.
    for (var k = 3; k >= 1; k--) {
      final gp = px((t - 0.006 * k).clamp(0.0, 1.0));
      _bird(canvas, gp, heading, unit * depth, phase - k * 0.35,
          (26 / k * fade).round(), 4.0);
    }
    _bird(canvas, pos, heading, unit * depth, phase, (255 * fade).round(), 0);
  }

  void _bird(Canvas canvas, Offset at, double heading, double s, double phase,
      int alpha, double blur) {
    if (alpha <= 0) return;
    canvas.save();
    canvas.translate(at.dx, at.dy);
    canvas.rotate(heading);
    canvas.scale(s, s);

    final body = Color.lerp(accent, const Color(0xFF0B0D0B), dark ? 0.38 : 0.12)!;
    final tail = Color.lerp(accent, const Color(0xFF0B0D0B), dark ? 0.55 : 0.34)!;
    final wingA = accent;
    final wingB = Color.lerp(accent, const Color(0xFFFFFFFF), dark ? 0.22 : 0.18)!;

    Paint fill(Color c) {
      final paint = Paint()..color = c.withAlpha(alpha);
      if (blur > 0) paint.maskFilter = MaskFilter.blur(BlurStyle.normal, blur / s);
      return paint;
    }

    // Tail feathers.
    for (final a in const [-0.3, 0.0, 0.3]) {
      _feather(canvas, const Offset(-0.34, 0), Offset(-0.34 - 0.42 * math.cos(a), 0.42 * math.sin(a)), 0.07, fill(tail));
    }

    // Wings. Flapping shortens the projected span at mid stroke.
    final stroke = 0.9 * math.sin(phase);
    final span = 0.98 * math.cos(stroke);
    final sweep = 0.30 + 0.22 * stroke;
    for (final side in const [1.0, -1.0]) {
      final shoulder = Offset(0.16, 0.09 * side);
      for (var k = 0; k < 6; k++) {
        final theta = math.pi / 2 + sweep + k * 0.15;
        final len = span * (1 - k * 0.085);
        final end = shoulder + Offset(math.cos(theta) * len, math.sin(theta) * len * side);
        _feather(canvas, shoulder, end, 0.085, fill(k.isEven ? wingA : wingB));
      }
      final cov = Path()
        ..addOval(Rect.fromCenter(center: shoulder + Offset(-0.02, 0.16 * side * span.abs()), width: 0.42, height: 0.2 * span.abs()));
      canvas.drawPath(cov, fill(body));
    }

    // Body, head and beak.
    canvas.drawOval(Rect.fromCenter(center: const Offset(0, 0), width: 0.9, height: 0.3), fill(body));
    canvas.drawCircle(const Offset(0.42, 0), 0.105, fill(body));
    final beak = Path()
      ..moveTo(0.49, -0.04)
      ..lineTo(0.62, 0)
      ..lineTo(0.49, 0.04)
      ..close();
    canvas.drawPath(beak, fill(ink));
    canvas.restore();
  }

  void _feather(Canvas c, Offset a, Offset b, double w, Paint paint) {
    final d = b - a;
    final len = d.distance;
    if (len == 0) return;
    final n = Offset(-d.dy / len, d.dx / len) * w;
    final mid = a + d * 0.5;
    final path = Path()
      ..moveTo(a.dx, a.dy)
      ..quadraticBezierTo((mid + n).dx, (mid + n).dy, b.dx, b.dy)
      ..quadraticBezierTo((mid - n * 0.6).dx, (mid - n * 0.6).dy, a.dx, a.dy)
      ..close();
    c.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _BirdPainter old) =>
      old.t != t || old.phase != phase || old.accent != accent;
}
