import 'package:flutter/material.dart';
import '../../../../../core/responsive/responsive.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/text_styles.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  static const _principles = [
    (
      'Build for real use',
      'Features should work beyond the ideal demo scenario.',
    ),
    (
      'Respect the existing system',
      'New functionality must fit the architecture and avoid unnecessary regressions.',
    ),
    (
      'Make complexity manageable',
      'Readable code, clear state management, and predictable behaviour make products easier to maintain.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final mobile = Responsive.isMobile(context);

    final copy = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'I approach development as a product problem as much as an '
          'engineering problem. A good feature needs to be understandable to '
          'its users, fit into the existing application architecture, and '
          'behave reliably across real devices and network conditions.',
          style: AppTextStyles.body(context, c.textSecondary),
        ),
        const SizedBox(height: 18),
        Text(
          'My work centres on Flutter applications, backend integrations, '
          'authentication flows, state management, and extending applications '
          'that are already in production. I value clear structure, '
          'maintainable code, and practical solutions that solve the actual '
          'problem.',
          style: AppTextStyles.body(context, c.textSecondary),
        ),
      ],
    );

    final principles = mobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final p in _principles)
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: _Principle(title: p.$1, body: p.$2),
                ),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < _principles.length; i++)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: i < _principles.length - 1 ? 32 : 0,
                    ),
                    child: _Principle(
                      title: _principles[i].$1,
                      body: _principles[i].$2,
                    ),
                  ),
                ),
            ],
          );

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
          child: mobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Beyond writing code.',
                      style: AppTextStyles.sectionTitle(context, c.textPrimary),
                    ),
                    const SizedBox(height: 28),
                    copy,
                    const SizedBox(height: 36),
                    principles,
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 42,
                      child: Text(
                        'Beyond writing code.',
                        style: AppTextStyles.sectionTitle(
                          context,
                          c.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 56),
                    Expanded(flex: 58, child: copy),
                  ],
                ),
        ),
      ),
    );
  }
}

class _Principle extends StatelessWidget {
  final String title;
  final String body;
  const _Principle({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(width: 28, height: 2, color: c.accentTeal),
        const SizedBox(height: 12),
        Text(
          title,
          style: AppTextStyles.body(
            context,
            c.textPrimary,
          ).copyWith(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(body, style: AppTextStyles.body(context, c.textSecondary)),
      ],
    );
  }
}
