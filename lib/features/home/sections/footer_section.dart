import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/content/profile.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/links.dart';
import '../../../core/resume/resume_download.dart';
import '../../../core/theme/palette.dart';
import '../../../core/theme/typography.dart';
import '../../../core/widgets/pressable.dart';
import '../widgets/nav_bar.dart';

/// Reads the dark palette, so it must sit inside a StageBlock.
class FooterSection extends StatelessWidget {
  const FooterSection({super.key, this.onNav});

  /// Index into the navigation labels, or -1 for the top. Null on pages that
  /// are not the home page, where the footer links back to it instead.
  final ValueChanged<int>? onNav;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Frame(
      child: LayoutBuilder(
        builder: (context, c) {
          final stacked = c.maxWidth < 900;

          Widget column(String title, List<Widget> links) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Typo.label(p, size: 13)),
                  const SizedBox(height: 10),
                  ...links,
                ],
              );

          final navigate = column('Navigate', [
            if (onNav != null)
              for (var i = 0; i < kNavLabels.length; i++)
                TextLink(label: kNavLabels[i], size: 15, onTap: () => onNav!(i))
            else
              TextLink(label: 'Home', size: 15, onTap: () => context.go('/')),
          ]);
          final elsewhere = column('Elsewhere', [
            TextLink(label: 'GitHub', size: 15, onTap: () => openExternal(Profile.github)),
            if (Profile.linkedin.isNotEmpty)
              TextLink(label: 'LinkedIn', size: 15, onTap: () => openExternal(Profile.linkedin)),
            TextLink(label: 'Email', size: 15, onTap: () => openExternal('mailto:${Profile.email}')),
            TextLink(label: 'Download résumé', size: 15, onTap: downloadResume),
          ]);

          final closing = Text(
            Profile.closing,
            style: Typo.display(p, stacked ? 34 : 48, height: 1.05),
          );

          return Padding(
            padding: EdgeInsets.only(top: stacked ? 24 : 40, bottom: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 1, color: p.border),
                SizedBox(height: stacked ? 48 : 72),
                if (stacked) ...[
                  closing,
                  const SizedBox(height: 40),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: navigate),
                      Expanded(child: elsewhere),
                    ],
                  ),
                ] else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 6, child: closing),
                      const SizedBox(width: 56),
                      Expanded(flex: 2, child: navigate),
                      Expanded(flex: 2, child: elsewhere),
                    ],
                  ),
                SizedBox(height: stacked ? 48 : 72),
                // The name set very large and very quiet, closing the page.
                ExcludeSemantics(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      Profile.name,
                      style: Typo.display(p, 184, height: 0.95, color: p.text.withAlpha(26)),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Wrap(
                  spacing: 28,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text('Copyright ${DateTime.now().year} ${Profile.name}', style: Typo.label(p, size: 13)),
                    Text(Profile.title, style: Typo.label(p, size: 13)),
                    if (onNav != null)
                      TextLink(label: 'Back to the top', size: 13, onTap: () => onNav!(-1)),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
