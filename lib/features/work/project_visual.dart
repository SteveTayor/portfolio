import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/content/projects.dart';
import '../../core/theme/palette.dart';

/// Screenshots are 720 by 1600, so a phone is this many times taller than it
/// is wide once the bezel is added.
const double kPhoneAspect = 2.154;

/// A real screenshot inside a phone bezel.
class PhoneShot extends StatelessWidget {
  const PhoneShot({super.key, required this.asset, required this.width});

  final String asset;
  final double width;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final h = width * kPhoneAspect;
    final r = width * 0.13;
    final bezel = width * 0.028;
    return Container(
      width: width,
      height: h,
      padding: EdgeInsets.all(bezel),
      decoration: BoxDecoration(
        color: Palette.bezel,
        borderRadius: BorderRadius.circular(r),
        border: Border.all(
          color: Palette.silverEdge.withAlpha(140),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x66000000),
            blurRadius: width * 0.22,
            offset: Offset(0, width * 0.09),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(r - bezel),
        child: Image.asset(
          asset,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
          gaplessPlayback: true,
          frameBuilder: (context, child, frame, sync) => AnimatedOpacity(
            opacity: (sync || frame != null) ? 1 : 0,
            duration: const Duration(milliseconds: 350),
            child: child,
          ),
          errorBuilder: (context, error, stack) => ColoredBox(color: p.surface),
        ),
      ),
    );
  }
}

/// Up to three screenshots arranged as a thumbnail that bleeds off the
/// bottom edge of its card. [hover] lifts the arrangement slightly.
class ProjectThumb extends StatelessWidget {
  const ProjectThumb({super.key, required this.project, this.hover = false});

  final Project project;
  final bool hover;

  @override
  Widget build(BuildContext context) {
    final imgs = project.images;
    return LayoutBuilder(
      builder: (context, c) {
        final h = c.maxHeight.isFinite ? c.maxHeight : 420.0;
        final w = c.maxWidth.isFinite ? c.maxWidth : 600.0;
        final frontH = math.min(h * 1.05, w * 0.9 * kPhoneAspect * 0.62);
        final fw = frontH / kPhoneAspect;
        final sideW = fw * 0.82;
        final lift = hover ? -h * 0.025 : 0.0;
        final cx = w / 2;
        return ClipRect(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              if (imgs.length > 2)
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 420),
                  curve: Curves.easeOutCubic,
                  left: cx - fw * 0.5 - sideW * 0.95,
                  top: h * 0.2 + lift,
                  child: Transform.rotate(
                    angle: -0.06,
                    child: PhoneShot(asset: imgs[2], width: sideW),
                  ),
                ),
              if (imgs.length > 1)
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 420),
                  curve: Curves.easeOutCubic,
                  left: cx + fw * 0.5 - sideW * 0.05,
                  top: h * 0.2 + lift,
                  child: Transform.rotate(
                    angle: 0.06,
                    child: PhoneShot(asset: imgs[1], width: sideW),
                  ),
                ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 420),
                curve: Curves.easeOutCubic,
                left: cx - fw / 2,
                top: h * 0.1 + lift,
                child: PhoneShot(asset: imgs[0], width: fw),
              ),
            ],
          ),
        );
      },
    );
  }
}
