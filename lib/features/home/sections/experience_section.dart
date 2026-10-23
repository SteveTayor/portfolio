import 'package:flutter/material.dart';

import '../../../core/content/story.dart';
import '../../../core/theme/palette.dart';
import '../../../core/theme/typography.dart';
import '../../../core/widgets/reveal.dart';
import '../../../core/widgets/section.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Section(
      color: p.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHead(
            label: 'Experience',
            title: 'Built through real product work.',
          ),
          const SizedBox(height: 72),
          for (final r in Story.roles)
            Reveal(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 34),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: p.border)),
                ),
                child: LayoutBuilder(
                  builder: (context, c) {
                    final stacked = c.maxWidth < 900;
                    final when = Text(r.period, style: Typo.label(p, size: 14));
                    final what = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.title, style: Typo.display(p, stacked ? 32 : 38)),
                        const SizedBox(height: 6),
                        Text(r.org,
                            style: Typo.body(p, size: 15, color: p.accent)),
                        const SizedBox(height: 16),
                        Text(r.summary, style: Typo.body(p, size: 16)),
                      ],
                    );
                    if (stacked) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [when, const SizedBox(height: 14), what],
                      );
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 280, child: when),
                        Expanded(child: what),
                      ],
                    );
                  },
                ),
              ),
            ),
          const Hairline(),
        ],
      ),
    );
  }
}
