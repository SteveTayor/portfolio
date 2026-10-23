import 'package:flutter/material.dart';

import '../../../core/content/story.dart';
import '../../../core/theme/palette.dart';
import '../../../core/theme/typography.dart';
import '../../../core/widgets/reveal.dart';
import '../../../core/widgets/section.dart';

class ExpertiseSection extends StatelessWidget {
  const ExpertiseSection({super.key});

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Section(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHead(
            label: 'Expertise',
            title: 'The engineering behind the interface.',
            body: 'My work spans the application layer, the services it '
                'depends on, and the details that keep a product maintainable '
                'as it evolves.',
          ),
          const SizedBox(height: 72),
          for (final n in Story.expertise)
            Reveal(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 40),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: p.border)),
                ),
                child: LayoutBuilder(
                  builder: (context, c) {
                    final stacked = c.maxWidth < 900;
                    final title = Text(
                      n.title,
                      style: Typo.display(p, stacked ? 36 : 44),
                    );
                    final body = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(n.body, style: Typo.body(p, size: 17)),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 26,
                          runSpacing: 8,
                          children: [
                            for (final t in n.tags)
                              Text(t, style: Typo.label(p, color: p.text2)),
                          ],
                        ),
                      ],
                    );
                    if (stacked) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [title, const SizedBox(height: 18), body],
                      );
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 5, child: title),
                        const SizedBox(width: 48),
                        Expanded(flex: 6, child: body),
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
