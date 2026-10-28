import 'package:flutter/material.dart';

import '../../../core/content/profile.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/theme/palette.dart';
import '../../../core/theme/typography.dart';
import '../../../core/widgets/pressable.dart';

const String kPortraitAsset = 'assets/portrait.webp';

/// The first frame. A name set large, one short line, and a portrait in an
/// arch. The same widget is shown on the laptop screen (at 1280 by 800) and as
/// the real hero, so the zoom lands on an identical frame.
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
        final nameSize = mobile
            ? (w < 380 ? 64.0 : 76.0)
            : (w >= 1240 ? 150.0 : (w >= 1080 ? 124.0 : 96.0));

        Widget copy() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 36, height: 1, color: p.accent),
                  const SizedBox(width: 14),
                  Text(
                    Profile.title,
                    style: Typo.label(p, color: p.accent, size: 14),
                  ),
                ],
              ),
              SizedBox(height: mobile ? 18 : 28),
              Text('Ayomide', style: Typo.display(p, nameSize, height: 0.92)),
              Text(
                'Arowolo',
                style: Typo.display(
                  p,
                  nameSize,
                  height: 0.92,
                  color: p.accent,
                  style: FontStyle.italic,
                ),
              ),
              SizedBox(height: mobile ? 18 : 30),
              Text(
                Profile.line,
                style: Typo.body(p, size: mobile ? 17 : 20, height: 1.4),
              ),
              SizedBox(height: mobile ? 22 : 34),
              Wrap(
                spacing: 28,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  PrimaryButton(
                    label: 'See the work',
                    onTap: interactive ? onWork : null,
                  ),
                  TextLink(
                    label: 'Get in touch',
                    onTap: interactive ? onContact : null,
                  ),
                ],
              ),
            ],
          );
        }

        if (mobile) {
          return Padding(
            padding: EdgeInsets.fromLTRB(padX, 96, padX, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.topLeft,
                  child: SizedBox(width: w - padX * 2, child: copy()),
                ),
                const SizedBox(height: 22),
                const Expanded(child: PortraitArch(fillWidth: true)),
              ],
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.fromLTRB(padX, 104, padX, 40),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 13,
                child: LayoutBuilder(
                  builder: (context, cc) => FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: SizedBox(width: cc.maxWidth, child: copy()),
                  ),
                ),
              ),
              const SizedBox(width: 40),
              const Expanded(flex: 9, child: PortraitArch()),
            ],
          ),
        );
      },
    );
  }
}

/// The portrait inside an arch, with a thin outline offset behind it.
class PortraitArch extends StatelessWidget {
  const PortraitArch({super.key, this.fillWidth = false});

  final bool fillWidth;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return LayoutBuilder(
      builder: (context, c) {
        var h = c.maxHeight;
        var w = fillWidth ? c.maxWidth : h * 0.8;
        if (w > c.maxWidth) {
          w = c.maxWidth;
          if (!fillWidth) h = w / 0.8;
        }
        final r = w / 2;
        return Align(
          alignment: fillWidth ? Alignment.bottomCenter : Alignment.center,
          child: SizedBox(
            width: w,
            height: h,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 16,
                  right: -16,
                  top: -14,
                  bottom: 14,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: p.border),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(r),
                        bottom: const Radius.circular(28),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(r),
                      bottom: const Radius.circular(28),
                    ),
                    child: Image.asset(
                      kPortraitAsset,
                      fit: BoxFit.cover,
                      alignment: const Alignment(0.1, -0.5),
                      gaplessPlayback: true,
                      frameBuilder: (context, child, frame, sync) =>
                          AnimatedOpacity(
                        opacity: (sync || frame != null) ? 1 : 0,
                        duration: const Duration(milliseconds: 600),
                        child: child,
                      ),
                      errorBuilder: (context, e, s) =>
                          ColoredBox(color: p.surface),
                    ),
                  ),
                ),
              ],
            ),
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
                        'Technologies',
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
