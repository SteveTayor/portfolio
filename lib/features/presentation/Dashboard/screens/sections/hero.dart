
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/constants/profile.dart';
import '../../../../../core/responsive/responsive.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/text_styles.dart';

class HeroSection extends StatefulWidget {
  final VoidCallback onExploreWork;
  const HeroSection({super.key, required this.onExploreWork});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _intro;

  @override
  void initState() {
    super.initState();
    _intro = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
  }

  @override
  void dispose() {
    _intro.dispose();
    super.dispose();
  }

  Animation<double> get _stagger(double start, double end) => CurvedAnimation(
        parent: _intro,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      );

  Future<void> _openResume() async {
    final uri = Uri.parse('assets/resume.pdf');
    await launchUrl(uri, webOnlyWindowName: '_blank');
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final mobile = Responsive.isMobile(context);
    final years = Profile.yearsExperience;

    final heading = Text.rich(
      TextSpan(
        style: AppTextStyles.hero(context, c.textPrimary),
        children: [
          const TextSpan(text: 'I build '),
          TextSpan(
            text: 'thoughtful mobile products',
            style: TextStyle(color: c.accentTeal),
          ),
          const TextSpan(text: ' that work in the real world.'),
        ],
      ),
    );

    final description = Text(
      "I'm a Flutter developer focused on building dependable cross-platform "
      'applications, integrating backend services, and turning product '
      'requirements into clear, usable experiences. I enjoy solving the '
      'details that make an application work well beyond the design stage.',
      style: AppTextStyles.body(context, c.textSecondary),
    );

    final meta = Text(
      '$years+ YEARS EXPERIENCE  ·  iOS & ANDROID  ·  FLUTTER',
      style: AppTextStyles.meta(c.textMuted),
    );

    final ctas = Wrap(
      spacing: 14,
      runSpacing: 12,
      children: [
        ElevatedButton(
          onPressed: widget.onExploreWork,
          child: const Text('Explore selected work'),
        ),
        OutlinedButton(
          onPressed: _openResume,
          child: const Text('View résumé'),
        ),
      ],
    );

    Widget textColumn({bool fullWidth = false}) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeTransition(
            opacity: _stagger(0.0, 0.25),
            child: Text(
              'FLUTTER MOBILE DEVELOPER · PRODUCT ENGINEERING',
              style: AppTextStyles.eyebrow(c.accentTeal),
            ),
          ),
          const SizedBox(height: 22),
          FadeTransition(
            opacity: _stagger(0.12, 0.4),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.06),
                end: Offset.zero,
              ).animate(_stagger(0.12, 0.4)),
              child: heading,
            ),
          ),
          const SizedBox(height: 22),
          FadeTransition(
            opacity: _stagger(0.32, 0.55),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: fullWidth ? 620 : 520),
              child: description,
            ),
          ),
          const SizedBox(height: 22),
          FadeTransition(
            opacity: _stagger(0.48, 0.66),
            child: meta,
          ),
          const SizedBox(height: 30),
          FadeTransition(
            opacity: _stagger(0.58, 0.8),
            child: ctas,
          ),
        ],
      );
    }

    final illustration = FadeTransition(
      opacity: _stagger(0.55, 0.95),
      child: SizedBox(
        height: mobile ? 320 : 460,
        child: Center(
          child: FittedBox(
            child: SizedBox(
              width: 300,
              height: 420,
              child: ProjectVisual(project: kProjects.first),
            ),
          ),
        ),
      ),
    );

    return mobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textColumn(fullWidth: true),
              const SizedBox(height: 40),
              illustration,
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(flex: 58, child: textColumn()),
              const SizedBox(width: 48),
              Expanded(flex: 42, child: illustration),
            ],
          );
  }
}
