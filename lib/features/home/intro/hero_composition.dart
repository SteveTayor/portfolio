import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/content/profile.dart';
import '../../../core/content/projects.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/theme/palette.dart';
import '../../../core/theme/typography.dart';
import '../../../core/widgets/pressable.dart';
import '../../work/project_visual.dart';

/// The hero. The same widget is shown on the laptop screen (at 1280 by 800)
/// and as the real first section, so the zoom lands on an identical frame.
class HeroComposition extends StatelessWidget {
  const HeroComposition({
    super.key,
    this.interactive = true,
    this.onWork,
    this.onContact,
  });

  final bool interactive;
  final VoidCallback? onWork;
  final VoidCallback? onContact;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        final mobile = w < Bp.mobile;
        final padX = Bp.pad(w);
        final head = mobile ? 46.0 : (w >= 1240 ? 78.0 : (w >= 1080 ? 68.0 : 56.0));

        Widget copy(double width) {
          return SizedBox(
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  Profile.title,
                  style: Typo.label(p, color: p.accent, size: 14),
                ),
                SizedBox(height: mobile ? 18 : 26),
                Text.rich(
                  TextSpan(
                    style: Typo.display(p, head, height: 1.02),
                    children: [
                      const TextSpan(
                        text: 'I build thoughtful mobile products that work in the ',
                      ),
                      TextSpan(
                        text: 'real world.',
                        style: Typo.display(
                          p,
                          head,
                          height: 1.02,
                          color: p.accent,
                          style: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 26),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Text(
                    Profile.intro,
                    style: Typo.body(p, size: mobile ? 16 : 18),
                  ),
                ),
                const SizedBox(height: 32),
                Wrap(
                  spacing: 28,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    PrimaryButton(
                      label: 'View selected work',
                      onTap: interactive ? onWork : null,
                    ),
                    TextLink(
                      label: 'Get in touch',
                      onTap: interactive ? onContact : null,
                    ),
                  ],
                ),
                const SizedBox(height: 34),
                Wrap(
                  spacing: 28,
                  runSpacing: 6,
                  children: [
                    Text(Profile.since, style: Typo.label(p)),
                    Text('iOS and Android', style: Typo.label(p)),
                    Text(Profile.location, style: Typo.label(p)),
                  ],
                ),
              ],
            ),
          );
        }

        if (mobile) {
          return Padding(
            padding: EdgeInsets.fromLTRB(padX, 104, padX, 32),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.topLeft,
              child: copy(w - padX * 2),
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.fromLTRB(padX, 112, padX, 44),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 11,
                child: LayoutBuilder(
                  builder: (context, cc) => FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: copy(cc.maxWidth),
                  ),
                ),
              ),
              const SizedBox(width: 48),
              Expanded(
                flex: 9,
                child: LayoutBuilder(
                  builder: (context, cc) {
                    final h = math.min(cc.maxHeight, cc.maxWidth / 0.74);
                    return Center(
                      child: ProjectDevices(
                        style: ProjectVisualStyle.fintech,
                        height: h,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// What the laptop screen shows: the hero plus a static copy of the top bar.
class ScreenFace extends StatelessWidget {
  const ScreenFace({super.key});

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return ColoredBox(
      color: p.bg,
      child: Stack(
        children: [
          const Positioned.fill(child: HeroComposition(interactive: false)),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(72, 30, 72, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(Profile.name, style: Typo.display(p, 26)),
                  Row(
                    children: [
                      for (final l in const [
                        'Work',
                        'About',
                        'Expertise',
                        'Experience',
                        'Contact',
                      ])
                        Padding(
                          padding: const EdgeInsets.only(left: 36),
                          child: Text(
                            l,
                            style: Typo.body(p, size: 15, height: 1.2),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
