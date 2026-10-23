import 'package:flutter/material.dart';

import '../../../core/theme/palette.dart';

/// A laptop drawn entirely in Flutter. [open] runs from 0 (lid closed) to 1
/// (lid open, screen lit). The [screen] is laid out at 1280 by 800 and scaled.
class MacBook extends StatelessWidget {
  const MacBook({
    super.key,
    required this.width,
    required this.open,
    required this.screen,
  });

  final double width;
  final double open;
  final Widget screen;

  static double lidHeight(double w) => w * 0.64;
  static double baseHeight(double w) => w * 0.042;
  static double inset(double w) => w * 0.022;

  /// The glass area inside the lid, in the laptop's own coordinates.
  static Rect screenRect(double w) {
    final i = inset(w);
    return Rect.fromLTRB(i, i, w - i, lidHeight(w) - i);
  }

  @override
  Widget build(BuildContext context) {
    final lidH = lidHeight(width);
    final baseH = baseHeight(width);
    final angle = (1 - open) * 1.48;
    final screenOn = ((open - 0.45) / 0.55).clamp(0.0, 1.0).toDouble();
    final i = inset(width);

    return SizedBox(
      width: width,
      height: lidH + baseH,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: lidH,
            height: baseH,
            child: _Base(width: width),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: lidH,
            child: Transform(
              alignment: Alignment.bottomCenter,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0007)
                ..rotateX(angle),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Palette.silver,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(width * 0.03),
                          bottom: Radius.circular(width * 0.004),
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Padding(
                      padding: EdgeInsets.all(width * 0.006),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Palette.bezel,
                          borderRadius: BorderRadius.circular(width * 0.024),
                        ),
                      ),
                    ),
                  ),
                  Positioned.fromRect(
                    rect: screenRect(width),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(width * 0.006),
                      child: Opacity(
                        opacity: screenOn,
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(width: 1280, height: 800, child: screen),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: i,
                    left: (width - width * 0.08) / 2,
                    width: width * 0.08,
                    height: width * 0.014,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Palette.bezel,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(width * 0.008),
                        ),
                      ),
                    ),
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

class _Base extends StatelessWidget {
  const _Base({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    final baseH = MacBook.baseHeight(width);
    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Palette.silver,
              borderRadius: BorderRadius.vertical(
                top: const Radius.circular(1),
                bottom: Radius.circular(width * 0.03),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x66000000),
                  blurRadius: width * 0.06,
                  offset: Offset(0, width * 0.03),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: width * 0.42,
          right: width * 0.42,
          height: baseH * 0.5,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Palette.silverEdge,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(width * 0.01),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
