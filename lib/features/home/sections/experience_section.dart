import 'package:flutter/material.dart';

import '../../../core/content/story.dart';
import '../../../core/resume/resume_download.dart';
import '../../../core/theme/palette.dart';
import '../../../core/theme/typography.dart';
import '../../../core/widgets/pressable.dart';
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
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          p.surface,
          Color.lerp(p.surface, p.atmosphereTeal, 0.09)!,
          p.surface,
        ],
      ),
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
          const SizedBox(height: 24),
          _ResumeCallout(onDownload: downloadResume),
          const SizedBox(height: 36),
          const Hairline(),
        ],
      ),
    );
  }
}


class _ResumeCallout extends StatelessWidget {
  const _ResumeCallout({required this.onDownload});

  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: p.border),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            p.raised,
            Color.lerp(p.raised, p.atmosphereTeal, 0.16)!,
            Color.lerp(p.raised, p.atmosphereBlue, 0.12)!,
          ],
        ),
      ),
      child: LayoutBuilder(
        builder: (context, c) {
          final stacked = c.maxWidth < 700;
          final message = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'A concise view of my experience.',
                style: Typo.display(p, stacked ? 24 : 29, height: 1.12),
              ),
              const SizedBox(height: 8),
              Text(
                'Résumé · PDF · Flutter, product work and experience',
                style: Typo.body(p, size: 14, height: 1.4),
              ),
            ],
          );
          if (stacked) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                message,
                const SizedBox(height: 20),
                PrimaryButton(label: 'Download résumé', onTap: onDownload),
              ],
            );
          }
          return Row(
            children: [
              Expanded(child: message),
              const SizedBox(width: 24),
              PrimaryButton(label: 'Download résumé', onTap: onDownload),
            ],
          );
        },
      ),
    );
  }
}
