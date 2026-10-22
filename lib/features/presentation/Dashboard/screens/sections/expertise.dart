import 'package:flutter/material.dart';

import '../../../../../core/responsive/responsive.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/text_styles.dart';

class ExpertiseSection extends StatelessWidget {
  const ExpertiseSection({super.key});

  static const _groups = [
    (
      'Mobile application development',
      'Flutter and Dart development for iOS and Android, with reusable '
          'widgets and component design, state management, responsive '
          'layouts, navigation and routing, and theme systems that keep '
          'the UI consistent.',
      ['Flutter', 'Dart', 'Riverpod', 'go_router'],
    ),
    (
      'Backend integration & services',
      'REST APIs and JSON, Firebase Authentication, application session '
          'management, and the states a real product needs  loading, '
          'error, empty and retry  plus secure local storage and network '
          'connectivity handling.',
      ['REST APIs', 'Firebase Auth', 'Flutter Secure Storage'],
    ),
    (
      'Quality, maintenance & delivery',
      'Debugging existing applications, building new functionality into '
          'shipped products, resolving UI and state-related issues, '
          'handling asynchronous data, and Git-based development with '
          'testing across supported devices.',
      ['Git', 'DevTools profiling', 'Unit & widget testing'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final mobile = Responsive.isMobile(context);

    return Padding(
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
                'The engineering behind the interface.',
                style: AppTextStyles.sectionTitle(context, c.textPrimary),
              ),
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Text(
                  'My work spans the application layer, the services it '
                  'depends on, and the details that keep a product '
                  'maintainable as it evolves.',
                  style: AppTextStyles.body(context, c.textSecondary),
                ),
              ),
              const SizedBox(height: 48),
              if (mobile)
                Column(
                  children: [
                    for (final g in _groups)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 32),
                        child: _Group(group: g),
                      ),
                  ],
                )
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final g in _groups)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 40),
                          child: _Group(group: g),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Group extends StatelessWidget {
  final (String, String, List<String>) group;
  const _Group({required this.group});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(width: 28, height: 2, color: c.accentTeal),
        const SizedBox(height: 14),
        Text(
          group.$1,
          style: AppTextStyles.body(
            context,
            c.textPrimary,
          ).copyWith(fontWeight: FontWeight.w700, fontSize: 17, height: 1.35),
        ),
        const SizedBox(height: 12),
        Text(group.$2, style: AppTextStyles.body(context, c.textSecondary)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final label in group.$3)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: c.border),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  label,
                  style: AppTextStyles.meta(
                    c.textSecondary,
                  ).copyWith(letterSpacing: 0.4, fontSize: 11.5),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
