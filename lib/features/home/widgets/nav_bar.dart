import 'package:flutter/material.dart';

import '../../../core/content/profile.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/links.dart';
import '../../../core/theme/palette.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/theme/typography.dart';
import '../../../core/widgets/pressable.dart';

const List<String> kNavLabels = [
  'Work',
  'About',
  'Technologies',
  'Experience',
  'Contact',
];

/// Below this width the links no longer fit and the menu takes over.
const double kNavCompact = 1000;

/// Fixed top bar. Hidden while the laptop intro plays (the laptop screen shows
/// its own copy), then fades in as the screen fills the window.
class NavBar extends StatelessWidget {
  const NavBar({
    super.key,
    required this.scroll,
    required this.travel,
    required this.onNav,
    required this.onMenu,
  });

  final ScrollController scroll;
  final double travel;
  final ValueChanged<int> onNav; // -1 means back to the top
  final VoidCallback onMenu;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scroll,
      builder: (context, _) {
        final off = scroll.hasClients ? scroll.offset : 0.0;
        final visible =
            (((off / travel) - 0.64) / 0.14).clamp(0.0, 1.0).toDouble();
        final solid = off > travel + 40;
        final p = Palette.of(context);
        return ExcludeFocus(
          excluding: visible < 0.1,
          child: IgnorePointer(
            ignoring: visible < 0.1,
            child: Opacity(
              opacity: visible,
              child: LayoutBuilder(
                builder: (context, c) {
                  final w = c.maxWidth;
                  final compact = w < kNavCompact;
                  final padX = Bp.pad(w);
                  final dark = Theme.of(context).brightness == Brightness.dark;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 240),
                    padding: EdgeInsets.fromLTRB(
                        padX, compact ? 14 : 22, padX, compact ? 14 : 18),
                    decoration: BoxDecoration(
                      color: solid ? p.bg.withAlpha(240) : Colors.transparent,
                      border: Border(
                        bottom: BorderSide(
                          color: solid ? p.border : Colors.transparent,
                        ),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Pressable(
                          label: 'Back to the top',
                          onTap: () => onNav(-1),
                          builder: (context, on) => Text(
                            Profile.name,
                            style: Typo.display(p, compact ? 22 : 26,
                                color: on ? p.accent : p.text),
                          ),
                        ),
                        const Spacer(),
                        if (!compact) ...[
                          for (var i = 0; i < kNavLabels.length; i++)
                            Padding(
                              padding: const EdgeInsets.only(left: 36),
                              child: Pressable(
                                label: kNavLabels[i],
                                onTap: () => onNav(i),
                                builder: (context, on) => Text(
                                  kNavLabels[i],
                                  style: Typo.body(
                                    p,
                                    size: 15,
                                    height: 1.2,
                                    color: on ? p.text : p.text2,
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(width: 28),
                          ThemePill(dark: dark),
                        ] else
                          Pressable(
                            label: 'Open the menu',
                            onTap: onMenu,
                            builder: (context, on) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: on ? p.accent : p.border),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Menu',
                                style: Typo.body(p,
                                    size: 14, height: 1.2, color: p.text),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

/// A two part switch: the active theme is filled, the other is a quiet label.
class ThemePill extends StatelessWidget {
  const ThemePill({super.key, required this.dark});

  final bool dark;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    Widget half(String label, bool active) => AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: active ? p.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Text(
            label,
            style: Typo.body(p,
                size: 13,
                height: 1.2,
                weight: FontWeight.w600,
                color: active ? p.onAccent : p.text2),
          ),
        );
    return Pressable(
      label: dark ? 'Switch to the light theme' : 'Switch to the dark theme',
      onTap: () =>
          ThemeScope.read(context).toggle(Theme.of(context).brightness),
      builder: (context, on) => Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          border: Border.all(color: on ? p.accent : p.border),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [half('Dark', dark), half('Light', !dark)],
        ),
      ),
    );
  }
}

/// Full screen menu for compact widths. Links rise in one after another.
class MobileMenu extends StatelessWidget {
  const MobileMenu({super.key, required this.onNav, required this.onClose});

  final ValueChanged<int> onNav;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
      builder: (context, v, child) => Opacity(opacity: v, child: child),
      child: Material(
        color: p.bg,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0.9, -0.9),
              radius: 1.2,
              colors: [p.surface, p.bg],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 14, 22, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(Profile.name, style: Typo.display(p, 22)),
                      const Spacer(),
                      Pressable(
                        label: 'Close the menu',
                        onTap: onClose,
                        builder: (context, on) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: on ? p.accent : p.border),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text('Close',
                              style: Typo.body(p,
                                  size: 14, height: 1.2, color: p.text)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, c) {
                        final tight = c.maxHeight < 520;
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              for (var i = 0; i < kNavLabels.length; i++)
                                TweenAnimationBuilder<double>(
                                  tween: Tween(begin: 0, end: 1),
                                  duration:
                                      Duration(milliseconds: 420 + i * 90),
                                  curve: Curves.easeOutCubic,
                                  builder: (context, v, child) => Opacity(
                                    opacity: v,
                                    child: Transform.translate(
                                      offset: Offset(0, (1 - v) * 24),
                                      child: child,
                                    ),
                                  ),
                                  child: Pressable(
                                    label: kNavLabels[i],
                                    onTap: () => onNav(i),
                                    builder: (context, on) => Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: tight ? 10 : 16),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(color: p.border),
                                        ),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.baseline,
                                        textBaseline: TextBaseline.alphabetic,
                                        children: [
                                          SizedBox(
                                            width: 44,
                                            child: Text(
                                              (i + 1).toString().padLeft(2, '0'),
                                              style: Typo.label(p),
                                            ),
                                          ),
                                          Text(
                                            kNavLabels[i],
                                            style: Typo.display(
                                              p,
                                              tight ? 40 : 54,
                                              color: on ? p.accent : p.text,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              Container(height: 1, color: p.border),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 18),
                  Pressable(
                    label: 'Email ${Profile.email}',
                    onTap: () => openExternal('mailto:${Profile.email}'),
                    builder: (context, on) => Text(
                      Profile.email,
                      style: Typo.body(p,
                          size: 16, height: 1.2, color: on ? p.accent : p.text),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      TextLink(
                          label: 'GitHub',
                          size: 14,
                          onTap: () => openExternal(Profile.github)),
                      const SizedBox(width: 22),
                      if (Profile.linkedin.isNotEmpty)
                        TextLink(
                            label: 'LinkedIn',
                            size: 14,
                            onTap: () => openExternal(Profile.linkedin)),
                      const Spacer(),
                      ThemePill(dark: dark),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
