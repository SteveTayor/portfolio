import 'package:flutter/material.dart';
import '../../../../../core/constants/profile.dart';
import '../../../../../core/responsive/responsive.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/text_styles.dart';

/// Sticky navigation. Compact desktop row; mobile gets a compact header
/// with an animated overlay menu.
class NavigationSection extends StatefulWidget {
  final bool scrolled;
  final int activeSection;
  final ValueChanged<int> onNavigate;
  final VoidCallback onToggleTheme;
  final bool isDark;

  const NavigationSection({
    super.key,
    required this.scrolled,
    required this.activeSection,
    required this.onNavigate,
    required this.onToggleTheme,
    required this.isDark,
  });

  static const sectionLabels = ['About', 'Work', 'Expertise', 'Experience'];

  @override
  State<NavigationSection> createState() => _NavigationSectionState();
}

class _NavigationSectionState extends State<NavigationSection> {
  bool _menuOpen = false;

  void _closeMenu() => setState(() => _menuOpen = false);

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final mobile = Responsive.isMobile(context);

    final menu = _MenuOverlay(
      open: _menuOpen,
      activeSection: widget.activeSection,
      onNavigate: (i) {
        _closeMenu();
        widget.onNavigate(i);
      },
      onClose: _closeMenu,
    );

    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: widget.scrolled
                ? c.bg.withOpacity(0.88)
                : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: widget.scrolled ? c.border : Colors.transparent,
              ),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: SizedBox(
              height: 64,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.sidePadding(context),
                ),
                child: Row(
                  children: [
                    _Wordmark(onTap: () => widget.onNavigate(-1)),
                    if (!mobile) ...[
                      const Spacer(),
                      for (
                        var i = 0;
                        i < NavigationSection.sectionLabels.length;
                        i++
                      )
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: _NavLink(
                            label: NavigationSection.sectionLabels[i],
                            active: widget.activeSection == i,
                            onTap: () => widget.onNavigate(i),
                          ),
                        ),
                      const Spacer(),
                    ] else
                      const Spacer(),
                    _ThemeToggle(
                      isDark: widget.isDark,
                      onTap: widget.onToggleTheme,
                    ),
                    const SizedBox(width: 10),
                    if (!mobile)
                      TextButton(
                        onPressed: () => widget.onNavigate(5),
                        style: TextButton.styleFrom(
                          foregroundColor: c.bg,
                          backgroundColor: c.accentTeal,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9),
                          ),
                        ),
                        child: Text(
                          "Let's talk",
                          style: AppTextStyles.button(c.bg),
                        ),
                      )
                    else
                      IconButton(
                        icon: Icon(
                          _menuOpen ? Icons.close : Icons.menu,
                          color: c.textPrimary,
                        ),
                        onPressed: () => setState(() => _menuOpen = !_menuOpen),
                        tooltip: _menuOpen ? 'Close menu' : 'Open menu',
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        menu,
      ],
    );
  }
}

class _MenuOverlay extends StatelessWidget {
  final bool open;
  final int activeSection;
  final ValueChanged<int> onNavigate;
  final VoidCallback onClose;

  const _MenuOverlay({
    required this.open,
    required this.activeSection,
    required this.onNavigate,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return IgnorePointer(
      ignoring: !open,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 220),
        opacity: open ? 1 : 0,
        child: Container(
          color: c.bg.withOpacity(0.97),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 88, 28, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (
                    var i = 0;
                    i < NavigationSection.sectionLabels.length;
                    i++
                  )
                    Padding(
                      padding: const EdgeInsets.only(bottom: 22),
                      child: InkWell(
                        onTap: () => onNavigate(i),
                        child: Text(
                          NavigationSection.sectionLabels[i],
                          style: AppTextStyles.sectionTitle(
                            context,
                            i == activeSection ? c.accentTeal : c.textPrimary,
                          ).copyWith(fontSize: 30),
                        ),
                      ),
                    ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => onNavigate(5),
                    style: TextButton.styleFrom(
                      foregroundColor: c.bg,
                      backgroundColor: c.accentTeal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 26,
                        vertical: 16,
                      ),
                    ),
                    child: Text(
                      "Let's talk",
                      style: AppTextStyles.button(c.bg),
                    ),
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

class _Wordmark extends StatelessWidget {
  final VoidCallback onTap;
  const _Wordmark({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomPaint(
            size: const Size(18, 18),
            painter: _MarkPainter(c.accentTeal),
          ),
          const SizedBox(width: 8),
          Text(
            Profile.wordmark,
            style: AppTextStyles.nav(
              c.textPrimary,
            ).copyWith(fontWeight: FontWeight.w700, letterSpacing: 1.6),
          ),
        ],
      ),
    );
  }
}

class _MarkPainter extends CustomPainter {
  final Color color;
  _MarkPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(0, size.height * 0.7),
      Offset(size.width, size.height * 0.7),
      paint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.25, size.height * 0.7),
      2.2,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      Offset(size.width * 0.7, size.height * 0.7),
      2.2,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.5, size.height * 0.7)
        ..lineTo(size.width * 0.62, size.height * 0.2)
        ..lineTo(size.width * 0.78, size.height * 0.2),
      paint,
    );
  }

  @override
  bool shouldRepaint(_MarkPainter old) => old.color != color;
}

class _NavLink extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _NavLink({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: active ? c.accentTeal : Colors.transparent,
              width: 1.4,
            ),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.nav(active ? c.textPrimary : c.textSecondary),
        ),
      ),
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  final bool isDark;
  final VoidCallback onTap;
  const _ThemeToggle({required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Semantics(
      button: true,
      label: isDark ? 'Switch to light theme' : 'Switch to dark theme',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: 56,
          height: 30,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: c.bgSecondary,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: c.border),
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            alignment: isDark ? Alignment.centerRight : Alignment.centerLeft,
            child: Icon(
              isDark ? Icons.nights_stay_outlined : Icons.wb_sunny_outlined,
              size: 15,
              color: c.accentTeal,
            ),
          ),
        ),
      ),
    );
  }
}
