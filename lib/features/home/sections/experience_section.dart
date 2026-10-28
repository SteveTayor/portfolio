import 'package:flutter/material.dart';

import '../../../core/content/story.dart';
import '../../../core/theme/palette.dart';
import '../../../core/theme/typography.dart';
import '../../../core/widgets/reveal.dart';
import '../../../core/widgets/section.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  /// Dates are hidden on purpose. Set to true to show them again.
  static const bool showDates = false;

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
                    final when = Text(showDates ? r.period : r.org,
                        style: Typo.label(p, size: 14, color: showDates ? p.muted : p.accent));
                    final what = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.title, style: Typo.display(p, stacked ? 32 : 38)),
                        if (showDates) ...[
                          const SizedBox(height: 6),
                          Text(r.org, style: Typo.body(p, size: 15, color: p.accent)),
                        ],
                        const SizedBox(height: 16),
                        Text(r.summary, style: Typo.body(p, size: 16, height: 1.5)),
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
