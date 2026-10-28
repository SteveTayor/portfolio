import 'package:flutter/material.dart';

import '../../core/theme/palette.dart';
import 'intro/hero_composition.dart';
import 'intro/intro_stage.dart';
import 'sections/about_section.dart';
import 'sections/contact_section.dart';
import 'sections/experience_section.dart';
import 'sections/process_section.dart';
import 'sections/technologies_section.dart';
import 'sections/work_section.dart';
import 'widgets/flying_bird.dart';
import 'widgets/nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scroll = ScrollController();

  // One key per section, each attached to exactly one widget for the life of
  // the page, so the tree never reparents them.
  late final List<GlobalKey> _keys =
      List<GlobalKey>.generate(6, (_) => GlobalKey());

  bool _menu = false;
  bool _warmed = false;

  // Section order: 0 work, 1 about, 2 technologies, 3 experience, 4 process,
  // 5 contact. Navigation index 4 (Contact) maps to section 5.
  static const int _contact = 5;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_warmed) return;
    _warmed = true;
    // Load the portrait before the laptop screen lights up.
    precacheImage(const AssetImage(kPortraitAsset), context)
        .catchError((Object _) {});
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _goTo(int navIndex) {
    if (_menu) setState(() => _menu = false);
    if (navIndex < 0) {
      _scroll.animateTo(
        0,
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeInOutCubic,
      );
      return;
    }
    final section = navIndex == 4 ? _contact : navIndex;
    final ctx = _keys[section].currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final vh = MediaQuery.sizeOf(context).height;
    final travel = vh * 2.2;

    return Scaffold(
      backgroundColor: p.bg,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scroll,
            child: Column(
              children: [
                IntroStage(
                  scroll: _scroll,
                  travel: travel,
                  onWork: () => _goTo(0),
                  onContact: () => _goTo(4),
                ),
                KeyedSubtree(key: _keys[0], child: const WorkSection()),
                KeyedSubtree(key: _keys[1], child: const AboutSection()),
                KeyedSubtree(key: _keys[2], child: const TechnologiesSection()),
                KeyedSubtree(key: _keys[3], child: const ExperienceSection()),
                KeyedSubtree(key: _keys[4], child: const ProcessSection()),
                KeyedSubtree(
                  key: _keys[5],
                  child: ContactSection(onNav: _goTo),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: FlyingBird(scroll: _scroll, start: travel + vh),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: NavBar(
              scroll: _scroll,
              travel: travel,
              onNav: _goTo,
              onMenu: () => setState(() => _menu = true),
            ),
          ),
          if (_menu)
            Positioned.fill(
              child: MobileMenu(
                onNav: _goTo,
                onClose: () => setState(() => _menu = false),
              ),
            ),
        ],
      ),
    );
  }
}
