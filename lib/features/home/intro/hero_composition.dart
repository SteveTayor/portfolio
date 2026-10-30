import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/content/profile.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/theme/palette.dart';
import '../../../core/theme/typography.dart';
import '../../../core/widgets/pressable.dart';

const String kPortraitAsset = 'assets/portrait.webp';

/// The same carefully composed frame is used on the laptop screen and in the
/// real intro. The portrait fills the desktop's right side; copy sits over a
/// soft fade at the image edge, rather than repeating the name from the nav.
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
        final headlineSize = mobile
            ? (w < 380 ? 38.0 : 46.0)
            : (w >= 1240 ? 72.0 : (w >= 1080 ? 64.0 : 54.0));

        Widget copy() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Container(width: 30, height: 1, color: p.accent),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      mobile && w < 380
                          // ? '${Profile.experience} · Flutter'
                          ? 'Flutter Developer'
                          : 'SENIOR Flutter Developer',

                      // : '${Profile.experience} ·SENIOR Flutter Developer',
                      style: Typo.label(
                        p,
                        color: p.accent,
                        size: mobile && w < 380 ? 11 : 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: mobile ? 18 : 24),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: mobile ? w : 680),
                child: Semantics(
                  header: true,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: 'The little things are the '),
                        TextSpan(
                          text: 'whole experience.',
                          // One deliberate italic accent. Italics stay available
                          // as an editorial detail, not a repeated visual rule.
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                    style: Typo.display(p, headlineSize, height: 1.05),
                  ),
                ),
              ),
              SizedBox(height: mobile ? 16 : 22),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: mobile ? w : 560),
                child: Text(
                  Profile.line,
                  style: Typo.body(p, size: mobile ? 15 : 18, height: 1.55),
                ),
              ),
              SizedBox(height: mobile ? 22 : 30),
              Wrap(
                spacing: 24,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  PrimaryButton(
                    label: 'Explore selected work',
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
            padding: EdgeInsets.fromLTRB(padX, 88, padX, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                copy(),
                const SizedBox(height: 22),
                const Expanded(child: PortraitArch(fillWidth: true)),
              ],
            ),
          );
        }

        return Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.hardEdge,
          children: [
            ColoredBox(color: p.bg),
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: w * 0.52,
              child: const PortraitArch(fillWidth: true, edgeToEdge: true),
            ),
            // The fade blends the image into the page without a visible card
            // boundary. The right edge of the portrait remains fully visible.
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: const [0.0, 0.37, 0.57, 0.82, 1.0],
                      colors: [
                        p.bg,
                        p.bg,
                        p.bg.withAlpha(226),
                        p.bg.withAlpha(105),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: padX,
              top: 88,
              bottom: 30,
              width: w * 0.55,
              child: Align(alignment: Alignment.centerLeft, child: copy()),
            ),
          ],
        );
      },
    );
  }
}

/// The portrait is a full-height, image-led composition on desktop and a
/// generously sized portrait on mobile. Both themes use the same neutral mask.
class PortraitArch extends StatelessWidget {
  const PortraitArch({
    super.key,
    this.fillWidth = false,
    this.edgeToEdge = false,
  });

  final bool fillWidth;
  final bool edgeToEdge;

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
        final fullBleedRadius = math.min(w * 0.52, h * 0.32);
        final shape = edgeToEdge
            ? BorderRadius.only(
                topLeft: Radius.circular(fullBleedRadius),
                bottomLeft: const Radius.circular(32),
              )
            : BorderRadius.vertical(
                top: Radius.circular(r),
                bottom: const Radius.circular(28),
              );

        return Align(
          alignment: fillWidth ? Alignment.bottomCenter : Alignment.center,
          child: SizedBox(
            width: w,
            height: h,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                if (!edgeToEdge)
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
                    borderRadius: shape,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
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
                        if (edgeToEdge)
                          DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  p.atmosphereTeal.withAlpha(28),
                                  Colors.transparent,
                                  p.atmosphereBlue.withAlpha(24),
                                ],
                              ),
                            ),
                          ),
                      ],
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

/// The laptop screen includes its own navigation as a realistic preview of the
/// site. The main headline no longer repeats the visitor-facing nav name.
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
                  Text(Profile.name, style: Typo.display(p, 22)),
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
