import 'package:flutter/material.dart';

import '../../../core/content/story.dart';
import '../../../core/theme/palette.dart';
import '../../../core/theme/typography.dart';
import '../../../core/widgets/reveal.dart';
import '../../../core/widgets/section.dart';

class ProcessSection extends StatelessWidget {
  const ProcessSection({super.key});

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Section(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHead(
            label: 'Process',
            title: 'From requirement to reliable release.',
          ),
          const SizedBox(height: 64),
          LayoutBuilder(
            builder: (context, c) {
              final stacked = c.maxWidth < 900;
              Widget step(int i) {
                final n = Story.process[i];
                return Reveal(
                  delay: Duration(milliseconds: 90 * i),
                  child: Container(
                    padding: const EdgeInsets.only(top: 22, right: 24, bottom: 28),
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: p.border)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (i + 1).toString().padLeft(2, '0'),
                          style: Typo.display(p, 56, color: p.accent),
                        ),
                        const SizedBox(height: 14),
                        Text(n.title, style: Typo.display(p, 30)),
                        const SizedBox(height: 10),
                        Text(n.body, style: Typo.body(p, size: 15)),
                      ],
                    ),
                  ),
                );
              }

              if (stacked) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [for (var i = 0; i < Story.process.length; i++) step(i)],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < Story.process.length; i++)
                    Expanded(child: step(i)),
                ],
              );
            },
          ),
          const SizedBox(height: 28),
          Text(
            'The shape of the process adapts to each engagement. This is the '
            'default, not a rigid contract.',
            style: Typo.label(p, size: 14),
          ),
        ],
      ),
    );
  }
}
