import 'package:flutter/material.dart';

import '../../../core/content/projects.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/theme/palette.dart';
import '../../../core/theme/typography.dart';
import '../../../core/widgets/pressable.dart';
import '../../../core/widgets/reveal.dart';
import '../../../core/widgets/section.dart';
import '../../work/project_overlay.dart';
import '../../work/project_visual.dart';

class WorkSection extends StatelessWidget {
  const WorkSection({super.key});

  @override
  Widget build(BuildContext context) {
    final list = Projects.shown;
    return Section(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHead(
            label: 'Selected work',
            title: 'Products, problems and the work behind them.',
            body: 'Open any project to see the screens.',
          ),
          const SizedBox(height: 64),
          LayoutBuilder(
            builder: (context, c) {
              final stacked = c.maxWidth < 900;
              if (stacked) {
                final h = c.maxWidth < Bp.mobile ? 470.0 : 540.0;
                return Column(
                  children: [
                    for (final pr in list)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: ProjectCard(project: pr, index: list.indexOf(pr), height: h),
                      ),
                  ],
                );
              }
              final rows = <Widget>[
                ProjectCard(project: list.first, index: 0, height: 620),
              ];
              for (var i = 1; i < list.length; i += 2) {
                rows.add(const SizedBox(height: 24));
                rows.add(
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: ProjectCard(project: list[i], index: i, height: 560)),
                      const SizedBox(width: 24),
                      i + 1 < list.length
                          ? Expanded(child: ProjectCard(project: list[i + 1], index: i + 1, height: 560))
                          : const Expanded(child: SizedBox()),
                    ],
                  ),
                );
              }
              return Column(children: rows);
            },
          ),
        ],
      ),
    );
  }
}

/// A project as a card: title above, real screens below, opening a gallery.
class ProjectCard extends StatelessWidget {
  const ProjectCard({
    super.key,
    required this.project,
    required this.index,
    required this.height,
  });

  final Project project;
  final int index;
  final double height;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Reveal(
      child: Pressable(
        label: 'Open the screens for ${project.title}',
        onTap: () => showProjectOverlay(context, project),
        builder: (context, hot) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: height,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: p.surface,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: hot ? p.accent.withAlpha(150) : p.border),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.only(top: 120),
                  child: ProjectThumb(project: project, hover: hot),
                ),
              ),
              Positioned(
                left: 28,
                top: 26,
                right: 28,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${(index + 1).toString().padLeft(2, '0')}   ${project.category}',
                      style: Typo.label(p, size: 13),
                    ),
                    const SizedBox(height: 8),
                    Text(project.title, style: Typo.display(p, 44, height: 1.0)),
                  ],
                ),
              ),
              Positioned(
                right: 22,
                top: 24,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 240),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: hot ? p.accent : Colors.transparent,
                    border: Border.all(color: hot ? p.accent : p.border),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'View screens',
                    style: Typo.body(p,
                        size: 13,
                        height: 1.2,
                        weight: FontWeight.w600,
                        color: hot ? p.onAccent : p.text2),
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
