import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/palette.dart';
import '../../../core/theme/typography.dart';
import 'hero_composition.dart';
import 'macbook.dart';

double _seg(double v, double a, double b) =>
    ((v - a) / (b - a)).clamp(0.0, 1.0).toDouble();

/// The cinematic opening. The laptop lid opens on load. Scrolling then
/// carries the camera into the screen, the laptop dissolves, and the real
/// hero takes its place. Everything is pinned for [travel] pixels of scroll.
class IntroStage extends StatefulWidget {
  const IntroStage({
    super.key,
    required this.scroll,
    required this.travel,
    required this.onWork,
    required this.onContact,
  });

  final ScrollController scroll;
  final double travel;
  final VoidCallback onWork;
  final VoidCallback onContact;

  @override
  State<IntroStage> createState() => _IntroStageState();
}

class _IntroStageState extends State<IntroStage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _open = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2800),
  );
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (MediaQuery.maybeOf(context)?.disableAnimations ?? false) {
      _open.value = 1;
    } else {
      Future<void>.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _open.forward();
      });
    }
  }

  @override
  void dispose() {
    _open.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final size = MediaQuery.sizeOf(context);
    final vw = size.width;
    final vh = size.height;
    final total = vh + widget.travel;

    final lw = (vw < 720 ? vw * 0.92 : math.min(vw * 0.64, vh * 1.15))
        .clamp(280.0, 1200.0)
        .toDouble();
    final totalH = MacBook.lidHeight(lw) + MacBook.baseHeight(lw);
    final top = (vh - totalH) / 2 - vh * 0.02;
    final sr = MacBook.screenRect(lw);
    final screenCentre = Offset(vw / 2, top + sr.center.dy);
    final wide = vw / vh > 1.25;
    final zoom = (wide
            ? math.max(vw / sr.width, vh / sr.height)
            : math.min(vw / sr.width, vh / sr.height)) *
        1.01;

    return SizedBox(
      height: total,
      child: AnimatedBuilder(
        animation: Listenable.merge([widget.scroll, _open]),
        builder: (context, _) {
          final off = widget.scroll.hasClients ? widget.scroll.offset : 0.0;
          final pin = off.clamp(0.0, widget.travel).toDouble();
          final prog = widget.travel <= 0 ? 0.0 : pin / widget.travel;
          // With reduced motion enabled, start on the final composition rather
          // than moving the camera or cross-fading through the laptop.
          final e = reduceMotion
              ? 1.0
              : Curves.easeInOutCubic.transform(_seg(prog, 0.0, 0.55));
          final fade = reduceMotion ? 1.0 : _seg(prog, 0.38, 0.54);
          final heroIn = reduceMotion ? 1.0 : _seg(prog, 0.46, 0.64);
          final open = Curves.easeInOutCubic.transform(_open.value);
          final cue = reduceMotion
              ? 0.0
              : (_seg(_open.value, 0.7, 1.0) *
                      (1 - _seg(prog, 0.0, 0.08)))
                  .toDouble();

          final scale = 1 + (zoom - 1) * e;
          final centre = Offset.lerp(screenCentre, Offset(vw / 2, vh / 2), e)!;
          final m = Matrix4.translationValues(centre.dx, centre.dy, 0.0) *
              Matrix4.diagonal3Values(scale, scale, 1.0) *
              Matrix4.translationValues(-screenCentre.dx, -screenCentre.dy, 0.0);

          return Stack(
            children: [
              Positioned(
                top: pin,
                left: 0,
                right: 0,
                height: vh,
                child: ClipRect(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              center: const Alignment(0, -0.1),
                              radius: 0.95,
                              colors: [p.surface, p.bg],
                            ),
                          ),
                        ),
                      ),
                      // A quiet three-tone atmosphere gives the opening depth
                      // in both themes without adding new UI accents.
                      Positioned(
                        left: -vw * 0.16,
                        top: -vh * 0.16,
                        width: vw * 0.76,
                        height: vh * 0.88,
                        child: IgnorePointer(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                radius: 1.05,
                                colors: [
                                  p.atmosphereTeal.withAlpha(95),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: -vw * 0.20,
                        top: -vh * 0.18,
                        width: vw * 0.78,
                        height: vh * 0.88,
                        child: IgnorePointer(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                radius: 1.0,
                                colors: [
                                  p.atmosphereBlue.withAlpha(83),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: vw * 0.08,
                        bottom: -vh * 0.24,
                        width: vw * 0.72,
                        height: vh * 0.64,
                        child: IgnorePointer(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                radius: 1.0,
                                colors: [
                                  p.atmosphereRose.withAlpha(48),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Opacity(
                          opacity: 1 - fade,
                          child: IgnorePointer(
                            child: Transform(
                              transform: m,
                              child: SizedBox(
                                width: vw,
                                height: vh,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: (vw - lw) / 2,
                                      top: top,
                                      width: lw,
                                      height: totalH,
                                      child: MacBook(
                                        width: lw,
                                        open: open,
                                        screen: const ScreenFace(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Opacity(
                          opacity: heroIn,
                          child: IgnorePointer(
                            ignoring: heroIn < 0.6,
                            child: HeroComposition(
                              onWork: widget.onWork,
                              onContact: widget.onContact,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 30,
                        child: Opacity(
                          opacity: cue,
                          child: Center(
                            child: Text(
                              'Scroll to enter',
                              style: Typo.label(p, size: 13),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
