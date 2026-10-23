import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/content/projects.dart';
import '../../core/theme/palette.dart';
import '../../core/theme/typography.dart';

/// A phone with a bezel and a screen drawn at a fixed 300 by 615 design size.
class PhoneFrame extends StatelessWidget {
  const PhoneFrame({super.key, required this.width, required this.screen});

  final double width;
  final Widget screen;

  @override
  Widget build(BuildContext context) {
    final h = width * 2.05;
    final r = width * 0.15;
    final bezel = width * 0.03;
    return Container(
      width: width,
      height: h,
      padding: EdgeInsets.all(bezel),
      decoration: BoxDecoration(
        color: Palette.bezel,
        borderRadius: BorderRadius.circular(r),
        border: Border.all(
          color: Palette.silverEdge.withAlpha(150),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x55000000),
            blurRadius: width * 0.2,
            offset: Offset(0, width * 0.08),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(r - bezel),
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(width: 300, height: 615, child: screen),
        ),
      ),
    );
  }
}

/// Two phones for a project: a main screen in front and a list behind it.
class ProjectDevices extends StatelessWidget {
  const ProjectDevices({super.key, required this.style, required this.height});

  final ProjectVisualStyle style;
  final double height;

  @override
  Widget build(BuildContext context) {
    final fh = math.max(height, 160.0);
    final fw = fh / 2.05;
    final bh = fh * 0.8;
    final bw = bh / 2.05;
    return SizedBox(
      width: fw + bw * 0.62,
      height: fh,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            child: PhoneFrame(width: bw, screen: _ListScreen(style: style)),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: PhoneFrame(width: fw, screen: _MainScreen(style: style)),
          ),
        ],
      ),
    );
  }
}

class _Face extends StatelessWidget {
  const _Face({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return ColoredBox(
      color: p.bg,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 58, 22, 22),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: child,
            ),
          ),
          Positioned(
            top: 14,
            left: 105,
            width: 90,
            height: 26,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Palette.bezel,
                borderRadius: BorderRadius.circular(13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _bar(Palette p, double w, {double h = 8}) => Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: p.border,
        borderRadius: BorderRadius.circular(h / 2),
      ),
    );

Widget _tile(Palette p, String t) => Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: p.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(t, style: Typo.label(p, size: 12, color: p.text2)),
    );

Widget _line(Palette p, String t) => Container(
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: p.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              t,
              style: Typo.body(p, size: 14, color: p.text, height: 1.2),
            ),
          ),
          _bar(p, 28, h: 6),
        ],
      ),
    );

Widget _slot(Palette p, String t, bool done) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: done ? p.accent : Colors.transparent,
              border: Border.all(color: done ? p.accent : p.border, width: 1.5),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              t,
              style: Typo.body(p, size: 14, color: p.text, height: 1.2),
            ),
          ),
          _bar(p, 34, h: 6),
        ],
      ),
    );

Widget _field(Palette p, String label) => Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Typo.label(p, size: 12)),
          const SizedBox(height: 14),
          Container(height: 1, color: p.border),
        ],
      ),
    );

Widget _bubble(Palette p, bool right) => Align(
      alignment: right ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: right ? p.raised : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: p.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_bar(p, 100), const SizedBox(height: 7), _bar(p, 58)],
        ),
      ),
    );

Widget _meter(Palette p, double f) => Container(
      height: 8,
      decoration: BoxDecoration(
        color: p.border,
        borderRadius: BorderRadius.circular(4),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: f,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: p.accent,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );

const List<double> _wave = [
  14, 30, 20, 44, 26, 52, 34, 18, 40, 24, 48, 16, 36, 28, 46, 22,
];

class _MainScreen extends StatelessWidget {
  const _MainScreen({required this.style});

  final ProjectVisualStyle style;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    switch (style) {
      case ProjectVisualStyle.fintech:
        return _Face(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Wallet', style: Typo.display(p, 36)),
              const SizedBox(height: 18),
              Container(
                height: 124,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: p.raised,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: p.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Available balance', style: Typo.label(p, size: 12)),
                    const Spacer(),
                    _bar(p, 120, h: 22),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(child: _tile(p, 'Send')),
                  const SizedBox(width: 8),
                  Expanded(child: _tile(p, 'Receive')),
                  const SizedBox(width: 8),
                  Expanded(child: _tile(p, 'Top up')),
                ],
              ),
              const SizedBox(height: 22),
              Text('Services', style: Typo.label(p, size: 12)),
              const SizedBox(height: 6),
              _line(p, 'Airtime'),
              _line(p, 'Data'),
              _line(p, 'Transfers'),
              _line(p, 'History'),
            ],
          ),
        );
      case ProjectVisualStyle.health:
        return _Face(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Today', style: Typo.display(p, 36)),
              const SizedBox(height: 18),
              Center(
                child: SizedBox(
                  width: 130,
                  height: 130,
                  child: CustomPaint(painter: _RingPainter(p.accent, p.border)),
                ),
              ),
              const SizedBox(height: 10),
              Center(child: Text('Adherence', style: Typo.label(p, size: 12))),
              const SizedBox(height: 20),
              _slot(p, 'Morning', true),
              _slot(p, 'Midday', true),
              _slot(p, 'Evening', false),
            ],
          ),
        );
      case ProjectVisualStyle.auth:
        return _Face(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Sign in', style: Typo.display(p, 40)),
              const SizedBox(height: 28),
              _field(p, 'Email'),
              _field(p, 'Password'),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: p.accent,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Continue',
                  style: Typo.body(
                    p,
                    size: 14,
                    color: p.onAccent,
                    weight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Center(
                child: Text('Verify your identity',
                    style: Typo.label(p, size: 12)),
              ),
            ],
          ),
        );
      case ProjectVisualStyle.audio:
        return _Face(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Room', style: Typo.display(p, 36)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: p.raised,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: p.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Now playing', style: Typo.label(p, size: 12)),
                    const SizedBox(height: 10),
                    _bar(p, 120, h: 10),
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 56,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          for (final h in _wave)
                            Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Container(
                                width: 6,
                                height: h,
                                decoration: BoxDecoration(
                                  color: p.accent,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _bubble(p, false),
              _bubble(p, true),
              _bubble(p, false),
            ],
          ),
        );
      case ProjectVisualStyle.license:
        return _Face(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Compare', style: Typo.display(p, 36)),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(child: _tile(p, 'License A')),
                  const SizedBox(width: 10),
                  Expanded(child: _tile(p, 'License B')),
                ],
              ),
              const SizedBox(height: 18),
              for (final t in const ['Permissions', 'Limits', 'Obligations'])
                Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t, style: Typo.label(p, size: 12)),
                      const SizedBox(height: 8),
                      _meter(p, t == 'Limits' ? 0.45 : 0.8),
                      const SizedBox(height: 6),
                      _meter(p, t == 'Limits' ? 0.7 : 0.5),
                    ],
                  ),
                ),
            ],
          ),
        );
    }
  }
}

class _ListScreen extends StatelessWidget {
  const _ListScreen({required this.style});

  final ProjectVisualStyle style;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    late final String title;
    late final List<String> rows;
    switch (style) {
      case ProjectVisualStyle.fintech:
        title = 'History';
        rows = const ['Airtime purchase', 'Data bundle', 'Wallet funding'];
      case ProjectVisualStyle.health:
        title = 'Reminders';
        rows = const ['Morning dose', 'Midday check', 'Evening dose'];
      case ProjectVisualStyle.auth:
        title = 'Verify';
        rows = const ['Email address', 'Identity check', 'Session'];
      case ProjectVisualStyle.audio:
        title = 'Rooms';
        rows = const ['Room one', 'Room two', 'Room three'];
      case ProjectVisualStyle.license:
        title = 'Metrics';
        rows = const ['Permissions', 'Limits', 'Obligations'];
    }
    return _Face(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: Typo.display(p, 34)),
          const SizedBox(height: 18),
          for (final r in rows) _line(p, r),
          const SizedBox(height: 22),
          Container(
            height: 110,
            decoration: BoxDecoration(
              color: p.raised,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: p.border),
            ),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter(this.color, this.track);

  final Color color;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(8, 8, size.width - 16, size.height - 16);
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..color = track;
    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..color = color;
    canvas.drawArc(rect, 0, math.pi * 2, false, base);
    canvas.drawArc(rect, -math.pi / 2, math.pi * 2 * 0.72, false, arc);
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.color != color || old.track != track;
}
