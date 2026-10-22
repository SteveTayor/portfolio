import 'package:flutter/material.dart';

import '../../../../../app/app.dart';
import '../../../../../core/animation/signal_controller.dart';
import '../../../../../core/responsive/responsive.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../widgets/signal_line.dart';
import '../../../../widgets/travelling_birid.dart';
import '../sections/about.dart';
import '../sections/contact.dart';
import '../sections/experience.dart';
import '../sections/expertise.dart';
import '../sections/footer.dart';
import '../sections/hero.dart';
import '../sections/navigation.dart';
import '../sections/process.dart';
import '../sections/projects.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scroll = ScrollController();
  final SignalController _signal = SignalController();
  final List<GlobalKey> _keys = List.generate(8, (_) => GlobalKey());
  bool _scrolled = false;
  int _active = -1;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll.dispose();
    _signal.dispose();
    super.dispose();
  }

  void _onScroll() {
    final pos = _scroll.position;
    _signal.updateScroll(pos.pixels, pos.maxScrollExtent);
    final nowScrolled = pos.pixels > 8;
    var active = -1;
    for (var i = 1; i <= 4; i++) {
      if (_signal.anchors.length > i &&
          _signal.anchors[i] <= pos.pixels + 240) {
        active = i - 1;
      }
    }
    if (nowScrolled != _scrolled || active != _active) {
      setState(() {
        _scrolled = nowScrolled;
        _active = active;
      });
    }
  }

  /// Measure each section's content-space position for the signal line.
  void _measureAnchors() {
    for (var i = 0; i < _keys.length; i++) {
      final rb = _keys[i].currentContext?.findRenderObject() as RenderBox?;
      if (rb != null && rb.hasSize) {
        _signal.setAnchor(i, rb.localToGlobal(Offset.zero).dy + _scroll.offset);
      }
    }
  }

  /// Nav indices: 0..3 = About/Work/Expertise/Experience, 5 = Let's talk,
  /// -1 = back to top. Sections: 0 hero, 1 about, 2 work, 3 expertise,
  /// 4 experience, 5 process, 6 contact, 7 footer.
  void _navigate(int navIndex) {
    if (navIndex < 0) {
      _scroll.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
      );
      return;
    }
    final sectionIndex = navIndex >= 5 ? 6 : navIndex + 1;
    final ctx = _keys[sectionIndex].currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeOutCubic,
        alignment: 0.02,
      );
    }
  }

  Widget _anchored(int i, Widget child) =>
      KeyedSubtree(key: _keys[i], child: child);

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final mobile = Responsive.isMobile(context);
    final reduced = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final viewportH = MediaQuery.sizeOf(context).height;

    WidgetsBinding.instance.addPostFrameCallback((_) => _measureAnchors());

    final sections = Column(
      children: [
        _anchored(
          0,
          LayoutBuilder(
            builder: (context, constraints) {
              return ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: mobile ? 0 : viewportH * 0.88,
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: mobile ? 96 : 140, bottom: 64),
                  child: HeroSection(onExploreWork: () => _navigate(1)),
                ),
              );
            },
          ),
        ),
        _anchored(1, const AboutSection()),
        _anchored(2, const ProjectsSection()),
        _anchored(3, const ExpertiseSection()),
        _anchored(4, const ExperienceSection()),
        _anchored(5, const ProcessSection()),
        _anchored(6, const ContactSection()),
        _anchored(7, const FooterSection()),
      ],
    );

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scroll,
            physics: const ClampingScrollPhysics(),
            child: sections,
          ),
          // Signal line + travelling bird: decoration only, never intercept input.
          Positioned(
            left: mobile ? null : 8,
            right: mobile ? 2 : null,
            top: 0,
            bottom: 0,
            child: SignalLine(
              controller: _signal,
              lineColor: c.border,
              activeColor: c.accentTeal,
              viewportHeight: viewportH,
            ),
          ),
          if (!reduced)
            AnimatedBuilder(
              animation: _signal,
              builder: (context, child) {
                return Positioned(
                  left: mobile ? null : 14,
                  right: mobile ? 8 : null,
                  top: _signal
                      .birdScreenY(viewportH)
                      .clamp(70.0, viewportH - 80),
                  child: IgnorePointer(
                    child: TravellingBird(
                      color: c.accentTeal,
                      width: mobile ? 34 : 44,
                    ),
                  ),
                );
              },
            )
          else
            Positioned(
              right: 8,
              top: 90,
              child: IgnorePointer(
                child: TravellingBird(
                  color: c.accentTeal,
                  width: 34,
                  reducedMotion: true,
                ),
              ),
            ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: NavigationSection(
              scrolled: _scrolled,
              activeSection: _active,
              onNavigate: _navigate,
              onToggleTheme: themeController.toggle,
              isDark: isDark,
            ),
          ),
        ],
      ),
    );
  }
}
