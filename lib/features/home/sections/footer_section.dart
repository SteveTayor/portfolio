import 'package:flutter/material.dart';

import '../../../core/content/profile.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/links.dart';
import '../../../core/theme/palette.dart';
import '../../../core/theme/typography.dart';
import '../../../core/widgets/pressable.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Frame(
      child: Padding(
        padding: const EdgeInsets.only(top: 64, bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(Profile.closing, style: Typo.display(p, 40, height: 1.1)),
            const SizedBox(height: 40),
            Container(height: 1, color: p.border),
            const SizedBox(height: 20),
            Wrap(
              spacing: 28,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(Profile.name, style: Typo.body(p, size: 14, color: p.text)),
                Text(Profile.title, style: Typo.label(p, size: 14)),
                TextLink(
                  label: 'GitHub',
                  size: 14,
                  onTap: () => openExternal(Profile.github),
                ),
                TextLink(
                  label: 'Email',
                  size: 14,
                  onTap: () => openExternal('mailto:${Profile.email}'),
                ),
                if (Profile.linkedin.isNotEmpty)
                  TextLink(
                    label: 'LinkedIn',
                    size: 14,
                    onTap: () => openExternal(Profile.linkedin),
                  ),
                Text(
                  'Copyright ${DateTime.now().year}',
                  style: Typo.label(p, size: 13),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
