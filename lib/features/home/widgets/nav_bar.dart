import 'package:flutter/material.dart';

import '../../../core/content/profile.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/theme/palette.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/theme/typography.dart';
import '../../../core/widgets/pressable.dart';

const List<String> kNavLabels = [
  'Work',
  'About',
  'Expertise',
  'Experience',
  'Contact',
];

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
                  final mobile = w < 940; // links need about 940 pixels
                  final padX = Bp.pad(w);
                  final dark = Theme.of(context).brightness == Brightness.dark;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 240),
                    padding: EdgeInsets.fromLTRB(padX, mobile ? 16 : 22, padX, mobile ? 16 : 18),
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
                            style: Typo.display(p, mobile ? 22 : 26,
                                color: on ? p.accent : p.text),
                          ),
                        ),
                        const Spacer(),
                        if (!mobile) ...[
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
                          Pressable(
                            label: dark
                                ? 'Switch to the light theme'
                                : 'Switch to the dark theme',
                            onTap: () => ThemeScope.read(context)
                                .toggle(Theme.of(context).brightness),
                            builder: (context, on) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: on ? p.accent : p.border,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                dark ? 'Light' : 'Dark',
                                style: Typo.body(p,
                                    size: 14, height: 1.2, color: p.text),
                              ),
                            ),
                          ),
                        ] else
                          Pressable(
                            label: 'Open the menu',
                            onTap: onMenu,
                            builder: (context, on) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                'Menu',
                                style: Typo.body(p,
                                    size: 15,
                                    height: 1.2,
                                    color: on ? p.accent : p.text),
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

class MobileMenu extends StatelessWidget {
  const MobileMenu({super.key, required this.onNav, required this.onClose});

  final ValueChanged<int> onNav;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: p.bg,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 16, 22, 28),
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
                    builder: (context, on) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text('Close',
                          style: Typo.body(p,
                              size: 15,
                              height: 1.2,
                              color: on ? p.accent : p.text)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              for (var i = 0; i < kNavLabels.length; i++)
                Pressable(
                  label: kNavLabels[i],
                  onTap: () => onNav(i),
                  builder: (context, on) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      kNavLabels[i],
                      style: Typo.display(p, 52,
                          color: on ? p.accent : p.text),
                    ),
                  ),
                ),
              const Spacer(),
              Pressable(
                label: dark ? 'Switch to the light theme' : 'Switch to the dark theme',
                onTap: () => ThemeScope.read(context)
                    .toggle(Theme.of(context).brightness),
                builder: (context, on) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    dark ? 'Light theme' : 'Dark theme',
                    style: Typo.body(p,
                        size: 16, height: 1.2, color: on ? p.text : p.text2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
