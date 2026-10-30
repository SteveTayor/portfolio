import 'package:flutter/material.dart';

import '../../../core/content/story.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/theme/palette.dart';
import '../../../core/theme/typography.dart';
import '../../../core/widgets/reveal.dart';
import '../../../core/widgets/section.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Section(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          p.surface,
          Color.lerp(p.surface, p.atmosphereRose, 0.07)!,
          Color.lerp(p.surface, p.atmosphereTeal, 0.06)!,
        ],
        stops: const [0.0, 0.52, 1.0],
      ),
      child: LayoutBuilder(
        builder: (context, c) {
          final stacked = c.maxWidth < 900;
          final heading = Reveal(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('About', style: Typo.label(p, color: p.accent, size: 14)),
                const SizedBox(height: 18),
                Text(
                  'Beyond writing code.',
                  style: Typo.display(p, stacked ? 40 : 58, height: 1.06),
                ),
              ],
            ),
          );
          final copy = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Reveal(child: Text(Story.aboutOne, style: Typo.body(p, size: 18))),
              const SizedBox(height: 22),
              Reveal(child: Text(Story.aboutTwo, style: Typo.body(p, size: 18))),
              const SizedBox(height: 48),
              for (var i = 0; i < Story.principles.length; i++)
                Reveal(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 26),
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: p.border)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 48,
                          child: Text(
                            (i + 1).toString().padLeft(2, '0'),
                            style: Typo.label(p),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(Story.principles[i].title,
                                  style: Typo.display(p, 27)),
                              const SizedBox(height: 8),
                              Text(Story.principles[i].body,
                                  style: Typo.body(p, size: 16)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
          if (stacked) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [heading, const SizedBox(height: 40), copy],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 5, child: heading),
              SizedBox(width: Bp.pad(c.maxWidth)),
              Expanded(flex: 6, child: copy),
            ],
          );
        },
      ),
    );
  }
}
