import 'package:flutter/material.dart';

import '../../../../../core/responsive/responsive.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/text_styles.dart';

class ExperienceEntry {
  final String role;
  final String org;
  final String period;
  final String description;
  const ExperienceEntry({
    required this.role,
    required this.org,
    required this.period,
    required this.description,
  });
}

/// Verified professional history (per CV), latest first.
const List<ExperienceEntry> kExperience = [
  ExperienceEntry(
    role: 'Flutter Mobile Architect',
    org: 'Bundlegram: fintech payment platform',
    period: 'Jun 2025 – Sep 2026',
    description:
        'Sole architect and developer of a live fintech payment platform: system architecture, BLoC state management across feature modules, REST and WebSocket integrations, dual-role onboarding with KYC, and CI/CD delivery to both stores.',
  ),
  ExperienceEntry(
    role: 'Mobile Developer (Flutter), Contract',
    org: 'TradeLenda: fintech, Lagos',
    period: 'Jun 2025 – Sep 2025',
    description:
        'Implemented the Firebase Authentication workflow, loan-application and investment UI workflows, and integrated a liveness-detection API into KYC onboarding. Profiled and reduced jank on low-end Android devices.',
  ),
  ExperienceEntry(
    role: 'Lead Flutter Developer',
    org: 'Medherence: digital health platform',
    period: 'Jan 2025 – Jun 2025',
    description:
        'Architected a HIPAA-aligned health application with Clean Architecture: animated medication timelines, a background-service reminder engine, encrypted local storage, and crash monitoring. Deployed to the App Store and Google Play.',
  ),
  ExperienceEntry(
    role: 'Mobile Developer',
    org: 'DoWell UX Living Lab',
    period: 'Nov 2022 – Dec 2024',
    description:
        'Built WebSocket-based real-time signalling for a video and audio call application, a QR scanner with CustomPainter overlays and Firebase integration, and automated end-to-end testing pipelines.',
  ),
  ExperienceEntry(
    role: 'Mobile Developer',
    org: 'DUKA Nigeria',
    period: 'Feb 2022 – Nov 2022',
    description:
        'Integrated the Paystack payment SDK into a marketplace app with secure transaction flows and encrypted session management.',
  ),
];

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final mobile = Responsive.isMobile(context);

    return Container(
      width: double.infinity,
      color: c.bgSecondary,
      padding: EdgeInsets.symmetric(
        vertical: Responsive.sectionSpacing(context),
        horizontal: Responsive.sidePadding(context),
      ),
      child: Center(
        child: SizedBox(
          width: Responsive.contentWidth(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Built through real product work.',
                style: AppTextStyles.sectionTitle(context, c.textPrimary),
              ),
              const SizedBox(height: 44),
              for (var i = 0; i < kExperience.length; i++)
                _TimelineItem(
                  entry: kExperience[i],
                  isLast: i == kExperience.length - 1,
                  compact: mobile,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final ExperienceEntry entry;
  final bool isLast;
  final bool compact;
  const _TimelineItem({
    required this.entry,
    required this.isLast,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final node = Container(
      width: 11,
      height: 11,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: c.accentTeal, width: 1.6),
        color: c.bgSecondary,
      ),
    );

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (compact) ...[
          Text(entry.period, style: AppTextStyles.meta(c.accentTeal)),
          const SizedBox(height: 6),
        ],
        Text(
          entry.role,
          style: AppTextStyles.body(
            context,
            c.textPrimary,
          ).copyWith(fontWeight: FontWeight.w700, fontSize: 16.5),
        ),
        const SizedBox(height: 4),
        Text(
          entry.org,
          style: AppTextStyles.body(
            context,
            c.textSecondary,
          ).copyWith(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Text(
            entry.description,
            style: AppTextStyles.body(context, c.textSecondary),
          ),
        ),
        if (!isLast) const SizedBox(height: 36) else const SizedBox(height: 4),
      ],
    );

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              node,
              if (!isLast)
                Expanded(child: Container(width: 1, color: c.border)),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: compact
                ? content
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 190,
                        child: Text(
                          entry.period,
                          style: AppTextStyles.meta(c.accentTeal),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(child: content),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
