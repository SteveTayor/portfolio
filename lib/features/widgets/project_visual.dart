import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/projects/project_model.dart';

/// Abstract, project-specific visual compositions for the carousel.
/// Every frame uses fictional, clearly illustrative sample data — never
/// presented as real financial or clinical results.
class ProjectVisual extends StatelessWidget {
  final Project project;
  const ProjectVisual({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final c = _Colors.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        color: c.panel,
        child: Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: _FramePainter(c))),
            Center(
              child: switch (project.visualStyle) {
                ProjectVisualStyle.fintechPhone => _PhoneMock(
                  kind: _PhoneKind.wallet,
                  colors: c,
                ),
                ProjectVisualStyle.healthDashboard => _HealthDashboard(
                  colors: c,
                ),
                ProjectVisualStyle.authFlow => _AuthFlowDiagram(colors: c),
                ProjectVisualStyle.realtimeAudio => _AudioWaveform(colors: c),
                ProjectVisualStyle.licenseTool => _LicenseDoc(colors: c),
              },
            ),
            Positioned(
              left: 12,
              bottom: 10,
              child: Text(
                'Illustrative sample data',
                style: GoogleFonts.inter(
                  fontSize: 10.5,
                  color: c.muted,
                  letterSpacing: 0.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Colors {
  final Color panel, stroke, strong, muted, accent, accentSoft;
  _Colors(
    this.panel,
    this.stroke,
    this.strong,
    this.muted,
    this.accent,
    this.accentSoft,
  );

  factory _Colors.of(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return dark
        ? _Colors(
            const Color(0xFF10182A),
            const Color(0xFF29344A),
            const Color(0xFFF4F7FB),
            const Color(0xFF7F8BA1),
            const Color(0xFF75D6C3),
            const Color(0xFF1B3B38),
          )
        : _Colors(
            const Color(0xFFFFFFFF),
            const Color(0xFFD8DEE5),
            const Color(0xFF192332),
            const Color(0xFF758198),
            const Color(0xFF287F73),
            const Color(0xFFDCEEEA),
          );
  }
}

class _FramePainter extends CustomPainter {
  final _Colors c;
  _FramePainter(this.c);

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = c.stroke.withOpacity(0.35)
      ..strokeWidth = 0.6;
    for (var x = 0.0; x < size.width; x += 36) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (var y = 0.0; y < size.height; y += 36) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
  }

  @override
  bool shouldRepaint(_FramePainter old) => old.c != c;
}

enum _PhoneKind { wallet }

class _PhoneMock extends StatelessWidget {
  final _PhoneKind kind;
  final _Colors colors;
  const _PhoneMock({required this.kind, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      height: 380,
      decoration: BoxDecoration(
        color: colors.panel,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: colors.stroke, width: 1.4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Wallet',
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: colors.strong,
                ),
              ),
              CircleAvatar(radius: 10, backgroundColor: colors.accentSoft),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.accentSoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Balance',
                  style: GoogleFonts.inter(fontSize: 10, color: colors.muted),
                ),
                Text(
                  '₦ 128,400.00',
                  style: GoogleFonts.manrope(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: colors.strong,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: ['Send', 'Top up', 'Airtime']
                .map(
                  (label) => Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 6),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: colors.stroke),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        label,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 9.5,
                          color: colors.strong,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 14),
          Text(
            'Recent transactions',
            style: GoogleFonts.inter(fontSize: 10.5, color: colors.muted),
          ),
          const SizedBox(height: 8),
          for (final t in const [
            ('Data bundle', '-₦1,200'),
            ('Wallet top up', '+₦5,000'),
            ('Transfer to Ada', '-₦3,500'),
            ('Airtime', '-₦500'),
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: colors.accentSoft,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        t.$1,
                        style: GoogleFonts.inter(
                          fontSize: 10.5,
                          color: colors.strong,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    t.$2,
                    style: GoogleFonts.inter(
                      fontSize: 10.5,
                      color: t.$2.startsWith('+')
                          ? colors.accent
                          : colors.muted,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _HealthDashboard extends StatelessWidget {
  final _Colors colors;
  const _HealthDashboard({required this.colors});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Adherence this week',
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: colors.strong,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 90,
            child: CustomPaint(
              size: const Size(300, 90),
              painter: _TimelinePainter(colors),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                .map(
                  (d) => Text(
                    d,
                    style: GoogleFonts.inter(fontSize: 10, color: colors.muted),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colors.accentSoft,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.notifications_outlined,
                  size: 16,
                  color: colors.accent,
                ),
                const SizedBox(width: 8),
                Text(
                  'Next dose: 8:00 PM',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: colors.strong,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelinePainter extends CustomPainter {
  final _Colors c;
  _TimelinePainter(this.c);

  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = c.stroke
      ..strokeWidth = 2;
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      line,
    );
    final dot = Paint()..color = c.accent;
    final dotDim = Paint()..color = c.stroke;
    for (var i = 0; i < 7; i++) {
      final x = size.width * (i / 6);
      final taken = i != 3 && i != 5;
      canvas.drawCircle(
        Offset(x, size.height / 2),
        taken ? 7 : 5,
        taken ? dot : dotDim,
      );
      if (taken) {
        canvas.drawCircle(
          Offset(x, size.height / 2),
          12,
          Paint()
            ..color = c.accent.withOpacity(0.18)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.4,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_TimelinePainter old) => old.c != c;
}

class _AuthFlowDiagram extends StatelessWidget {
  final _Colors colors;
  const _AuthFlowDiagram({required this.colors});

  @override
  Widget build(BuildContext context) {
    Widget node(String label, bool filled) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: filled ? colors.accentSoft : colors.panel,
        border: Border.all(
          color: filled ? colors.accent : colors.stroke,
          width: 1.2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          color: colors.strong,
        ),
      ),
    );

    return SizedBox(
      width: 320,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          node('Sign in · Firebase Auth', true),
          _Arrow(colors: colors),
          node('ID + liveness check (KYC)', true),
          _Arrow(colors: colors),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              node('Loan application', false),
              const SizedBox(width: 12),
              node('Investments', false),
            ],
          ),
        ],
      ),
    );
  }
}

class _Arrow extends StatelessWidget {
  final _Colors colors;
  const _Arrow({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: CustomPaint(
        size: const Size(12, 26),
        painter: _ArrowPainter(colors),
      ),
    );
  }
}

class _ArrowPainter extends CustomPainter {
  final _Colors c;
  _ArrowPainter(this.c);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = c.accent
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height - 7),
      paint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(size.width / 2 - 4, size.height - 11)
        ..lineTo(size.width / 2, size.height - 3)
        ..lineTo(size.width / 2 + 4, size.height - 11),
      paint,
    );
  }

  @override
  bool shouldRepaint(_ArrowPainter old) => old.c != c;
}

class _AudioWaveform extends StatelessWidget {
  final _Colors colors;
  const _AudioWaveform({required this.colors});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomPaint(size: const Size(300, 72), painter: _WavePainter(colors)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < 4; i++)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: i == 0 ? colors.accent : colors.accentSoft,
                    child: Text(
                      '${i + 1}',
                      style: GoogleFonts.inter(
                        fontSize: 8.5,
                        fontWeight: FontWeight.w700,
                        color: colors.strong,
                      ),
                    ),
                  ),
                ),
              Text(
                '4 listening',
                style: GoogleFonts.inter(fontSize: 10.5, color: colors.muted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  final _Colors c;
  _WavePainter(this.c);

  @override
  void paint(Canvas canvas, Size size) {
    final mid = size.height / 2;
    final bar = Paint()..color = c.accent;
    final count = 36;
    for (var i = 0; i < count; i++) {
      final x = size.width * (i / (count - 1));
      final envelope = math.exp(
        -math.pow((i - count / 2) / (count / 3), 2).toDouble(),
      );
      final hgt =
          6 +
          envelope * (size.height - 14) * (0.35 + 0.65 * ((i * 37 % 10) / 10));
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(x, mid), width: 4, height: hgt),
          const Radius.circular(2),
        ),
        bar..color = c.accent.withOpacity(0.45 + envelope * 0.55),
      );
    }
  }

  @override
  bool shouldRepaint(_WavePainter old) => old.c != c;
}

class _LicenseDoc extends StatelessWidget {
  final _Colors colors;
  const _LicenseDoc({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.panel,
        border: Border.all(color: colors.stroke),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MIT vs Apache-2.0',
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: colors.strong,
            ),
          ),
          const SizedBox(height: 10),
          for (final row in const [
            ('Patent grant', true, false),
            ('Trademark use', false, false),
            ('Liability', true, true),
            ('Commercial use', true, true),
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    row.$1,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: colors.strong,
                    ),
                  ),
                  Text(
                    row.$2 ? 'Yes' : 'No',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: row.$2 ? colors.accent : colors.muted,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
