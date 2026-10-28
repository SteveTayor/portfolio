import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../core/content/projects.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/palette.dart';
import '../../core/theme/typography.dart';
import '../../core/widgets/pressable.dart';
import 'project_visual.dart';

/// Opens the screenshot gallery for a project above the page.
Future<void> showProjectOverlay(BuildContext context, Project project) {
  final router = GoRouter.of(context);
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Close gallery',
    barrierColor: const Color(0xE6070907),
    transitionDuration: const Duration(milliseconds: 340),
    pageBuilder: (dialogContext, a, b) => ProjectOverlay(
      project: project,
      onCase: () {
        Navigator.of(dialogContext).pop();
        router.go('/work/${project.id}');
      },
    ),
    transitionBuilder: (context, animation, secondary, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(scale: Tween<double>(begin: 0.97, end: 1).animate(curved), child: child),
      );
    },
  );
}

class ProjectOverlay extends StatefulWidget {
  const ProjectOverlay({super.key, required this.project, required this.onCase});

  final Project project;
  final VoidCallback onCase;

  @override
  State<ProjectOverlay> createState() => _ProjectOverlayState();
}

class _ProjectOverlayState extends State<ProjectOverlay> {
  int _i = 0;

  void _go(int n) {
    final count = widget.project.images.length;
    if (n < 0 || n >= count || n == _i) return;
    setState(() => _i = n);
  }

  @override
  Widget build(BuildContext context) {
    // The gallery always sits on a dark backdrop, so it uses the dark palette.
    final p = Palette.dark;
    final pr = widget.project;
    final close = () => Navigator.of(context).pop();

    return Theme(
      data: AppTheme.stage,
      child: CallbackShortcuts(
        bindings: <ShortcutActivator, VoidCallback>{
          const SingleActivator(LogicalKeyboardKey.escape): close,
          const SingleActivator(LogicalKeyboardKey.arrowRight): () => _go(_i + 1),
          const SingleActivator(LogicalKeyboardKey.arrowLeft): () => _go(_i - 1),
        },
        child: Focus(
          autofocus: true,
          child: Material(
            type: MaterialType.transparency,
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, c) {
                  final stacked = c.maxWidth < 900;
                  final avail = c.maxHeight - (stacked ? 330 : 190);
                  final phoneH = avail.clamp(300.0, 720.0).toDouble();
                  final phoneW = phoneH / kPhoneAspect;

                  final viewer = GestureDetector(
                    onHorizontalDragEnd: (d) {
                      final v = d.primaryVelocity ?? 0;
                      if (v < -250) _go(_i + 1);
                      if (v > 250) _go(_i - 1);
                    },
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 320),
                      child: PhoneShot(
                        key: ValueKey<int>(_i),
                        asset: pr.images[_i],
                        width: phoneW,
                      ),
                    ),
                  );

                  final info = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(pr.category, style: Typo.label(p, color: p.accent, size: 14)),
                      const SizedBox(height: 12),
                      Text(pr.title, style: Typo.display(p, stacked ? 44 : 64, height: 1.0)),
                      const SizedBox(height: 16),
                      Text(pr.summary, style: Typo.body(p, size: 16, height: 1.5)),
                      const SizedBox(height: 16),
                      Text(pr.role, style: Typo.body(p, size: 15, color: p.text)),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 16,
                        runSpacing: 6,
                        children: [for (final t in pr.technologies) Text(t, style: Typo.label(p))],
                      ),
                      const SizedBox(height: 18),
                      TextLink(label: 'Read the case study', onTap: widget.onCase),
                    ],
                  );

                  final head = Padding(
                    padding: EdgeInsets.fromLTRB(stacked ? 22 : 48, 20, stacked ? 22 : 48, 0),
                    child: Row(
                      children: [
                        Text(
                          '${(_i + 1).toString().padLeft(2, '0')} of '
                          '${pr.images.length.toString().padLeft(2, '0')}',
                          style: Typo.label(p),
                        ),
                        const Spacer(),
                        Pressable(
                          label: 'Close gallery',
                          onTap: close,
                          builder: (context, on) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                            decoration: BoxDecoration(
                              border: Border.all(color: on ? p.accent : p.border),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text('Close', style: Typo.body(p, size: 14, height: 1.2, color: p.text)),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (stacked) {
                    return Column(
                      children: [
                        head,
                        const SizedBox(height: 12),
                        Expanded(child: Center(child: viewer)),
                        const SizedBox(height: 10),
                        Center(child: SizedBox(height: 56, child: _MiniStrip(project: pr, index: _i, onTap: _go, p: p))),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 190,
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 22),
                            child: info,
                          ),
                        ),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      head,
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 5,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(child: Center(child: viewer)),
                                    const SizedBox(height: 14),
                                    Center(child: SizedBox(height: 60, child: _MiniStrip(project: pr, index: _i, onTap: _go, p: p))),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 56),
                              Expanded(flex: 4, child: SingleChildScrollView(child: info)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniStrip extends StatelessWidget {
  const _MiniStrip({required this.project, required this.index, required this.onTap, required this.p});

  final Project project;
  final int index;
  final ValueChanged<int> onTap;
  final Palette p;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < project.images.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Pressable(
              label: 'Show screen ${i + 1}',
              onTap: () => onTap(i),
              builder: (context, on) => AnimatedContainer(
                duration: const Duration(milliseconds: 240),
                width: 26,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: i == index ? p.accent : (on ? p.text2 : p.border), width: 1.4),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Opacity(
                    opacity: i == index ? 1 : 0.55,
                    child: Image.asset(
                      project.images[i],
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      errorBuilder: (context, e, s) => ColoredBox(color: p.surface),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
