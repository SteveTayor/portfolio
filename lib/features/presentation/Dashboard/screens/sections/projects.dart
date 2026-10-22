import 'package:flutter/material.dart';
import '../../../../../core/responsive/responsive.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/text_styles.dart';
import '../../../../widgets/project_carousel.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

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
                'SELECTED WORK / 01',
                style: AppTextStyles.eyebrow(c.accentTeal),
              ),
              const SizedBox(height: 16),
              Text(
                'Products, problems, and the work behind them.',
                style: AppTextStyles.sectionTitle(context, c.textPrimary),
              ),
              const SizedBox(height: 14),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Text(
                  'A closer look at the applications I\'ve contributed to, '
                  'the systems behind their experiences, and the engineering '
                  'decisions that make their features work.',
                  style: AppTextStyles.body(context, c.textSecondary),
                ),
              ),
              const SizedBox(height: 40),
              const ProjectCarousel(),
            ],
          ),
        ),
      ),
    );
  }
}
