import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../core/content/projects.dart';
import '../../../core/theme/palette.dart';
import '../../../core/theme/typography.dart';
import '../../../core/widgets/pressable.dart';
import '../../../core/widgets/section.dart';
import '../../work/project_visual.dart';

class WorkSection extends StatefulWidget {
  const WorkSection({super.key});

  @override
  State<WorkSection> createState() => _WorkSectionState();
}

class _WorkSectionState extends State<WorkSection> {
  int _index = 0;
  int _dir = 1;

  void _go(int next) {
    if (next < 0 || next >= Projects.all.length || next == _index) return;
    setState(() {
      _dir = next > _index ? 1 : -1;
      _index = next;
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final count = Projects.all.length;
    return Section(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHead(
            label: 'Selected work',
            title: 'Products, problems and the work behind them.',
            body: 'The applications I have contributed to and the engineering '
                'decisions behind their features.',
          ),
          const SizedBox(height: 64),
          CallbackShortcuts(
            bindings: <ShortcutActivator, VoidCallback>{
              const SingleActivator(LogicalKeyboardKey.arrowRight): () =>
                  _go(_index + 1),
              const SingleActivator(LogicalKeyboardKey.arrowLeft): () =>
                  _go(_index - 1),
            },
            child: Focus(
              child: GestureDetector(
                onHorizontalDragEnd: (d) {
                  final v = d.primaryVelocity ?? 0;
                  if (v < -250) _go(_index + 1);
                  if (v > 250) _go(_index - 1);
                },
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 420),
                  curve: Curves.easeOutCubic,
                  alignment: Alignment.topCenter,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 460),
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset(0.04 * _dir, 0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    ),
                    child: KeyedSubtree(
                      key: ValueKey<int>(_index),
                      child: _Stage(project: Projects.all[_index]),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 28,
            runSpacing: 12,
            children: [
              Opacity(
                opacity: _index == 0 ? 0.35 : 1,
                child: TextLink(
                  label: 'Previous',
                  onTap: _index == 0 ? null : () => _go(_index - 1),
                ),
              ),
              Opacity(
                opacity: _index == count - 1 ? 0.35 : 1,
                child: TextLink(
                  label: 'Next',
                  onTap: _index == count - 1 ? null : () => _go(_index + 1),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < count; i++)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: i == _index ? 40 : 18,
                        height: 2,
                        color: i == _index ? p.accent : p.border,
                      ),
                    ),
                ],
              ),
              Text(
                '${(_index + 1).toString().padLeft(2, '0')} of '
                '${count.toString().padLeft(2, '0')}',
                style: Typo.label(p),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stage extends StatelessWidget {
  const _Stage({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return LayoutBuilder(
      builder: (context, c) {
        final stacked = c.maxWidth < 900;

        final text = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              project.number.toString().padLeft(2, '0'),
              style: Typo.label(p, color: p.accent, size: 14),
            ),
            const SizedBox(height: 14),
            Text(project.title, style: Typo.display(p, stacked ? 48 : 68)),
            const SizedBox(height: 10),
            Text(project.category, style: Typo.label(p, size: 14)),
            const SizedBox(height: 22),
            Text(project.summary, style: Typo.body(p, size: 17)),
            const SizedBox(height: 20),
            Text(project.role, style: Typo.body(p, size: 15, color: p.text)),
            const SizedBox(height: 14),
            Wrap(
              spacing: 18,
              runSpacing: 6,
              children: [
                for (final t in project.technologies)
                  Text(t, style: Typo.label(p)),
              ],
            ),
            const SizedBox(height: 22),
            TextLink(
              label: 'Read the case study',
              onTap: () => context.go('/work/${project.id}'),
            ),
          ],
        );

        final plate = Container(
          height: stacked ? 460 : 620,
          decoration: BoxDecoration(
            color: p.surface,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: p.border),
          ),
          child: Stack(
            children: [
              Center(
                child: ProjectDevices(
                  style: project.style,
                  height: stacked ? 340 : 500,
                ),
              ),
              Positioned(
                left: 22,
                bottom: 16,
                child: Text('Illustrative interface',
                    style: Typo.label(p, size: 12)),
              ),
            ],
          ),
        );

        if (stacked) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [plate, const SizedBox(height: 32), text],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.only(right: 64),
                child: text,
              ),
            ),
            Expanded(flex: 6, child: plate),
          ],
        );
      },
    );
  }
}
