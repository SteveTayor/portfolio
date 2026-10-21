import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/constants/profile.dart';
import '../../../../../core/responsive/responsive.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/text_styles.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        Responsive.sidePadding(context),
        40,
        Responsive.sidePadding(context),
        48,
      ),
      child: Center(
        child: SizedBox(
          width: Responsive.contentWidth(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(color: c.border),
              const SizedBox(height: 36),
              Text(
                Profile.wordmark,
                style: AppTextStyles.nav(
                  c.textPrimary,
                ).copyWith(fontWeight: FontWeight.w700, letterSpacing: 1.6),
              ),
              const SizedBox(height: 6),
              Text(Profile.title, style: AppTextStyles.meta(c.textMuted)),
              const SizedBox(height: 18),
              Text(
                'Thoughtful software starts with understanding the problem.',
                style: AppTextStyles.body(context, c.textSecondary),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 24,
                runSpacing: 10,
                children: [
                  _link(
                    context,
                    'Email',
                    Uri(scheme: 'mailto', path: Profile.email),
                  ),
                  _link(context, 'GitHub', Uri.parse(Profile.github)),
                  if (Profile.linkedin.isNotEmpty)
                    _link(context, 'LinkedIn', Uri.parse(Profile.linkedin)),
                  _link(context, 'Résumé', Uri.parse(Profile.resumeAsset)),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                '© ${DateTime.now().year} ${Profile.name}. All rights reserved.',
                style: AppTextStyles.meta(c.textMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _link(BuildContext context, String label, Uri uri) => InkWell(
    onTap: () => launchUrl(
      uri,
      mode: label == 'Email'
          ? LaunchMode.platformDefault
          : LaunchMode.externalApplication,
    ),
    borderRadius: BorderRadius.circular(6),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        label,
        style: AppTextStyles.button(AppColors.of(context).accentTeal),
      ),
    ),
  );
}
