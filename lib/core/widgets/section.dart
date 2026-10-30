import 'package:flutter/material.dart';

import '../layout/responsive.dart';
import '../theme/palette.dart';
import '../theme/typography.dart';
import 'reveal.dart';

class Section extends StatelessWidget {
  const Section({super.key, required this.child, this.color, this.gradient});

  final Widget child;
  final Color? color;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final vertical = constraints.maxWidth < Bp.mobile ? 80.0 : 128.0;
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: gradient == null ? color : null,
            gradient: gradient,
          ),
          padding: EdgeInsets.symmetric(vertical: vertical),
          child: Frame(child: child),
        );
      },
    );
  }
}

class SectionHead extends StatelessWidget {
  const SectionHead({
    super.key,
    required this.label,
    required this.title,
    this.body,
  });

  final String label;
  final String title;
  final String? body;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final mobile = constraints.maxWidth < Bp.mobile;
        return Reveal(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Typo.label(p, color: p.accent, size: 14)),
              const SizedBox(height: 18),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Semantics(
                  header: true,
                  child: Text(
                    title,
                    style: Typo.display(p, mobile ? 38 : 58, height: 1.05),
                  ),
                ),
              ),
              if (body != null) ...[
                const SizedBox(height: 22),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Text(body!, style: Typo.body(p, size: 17)),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class Hairline extends StatelessWidget {
  const Hairline({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: Palette.of(context).border);
  }
}
