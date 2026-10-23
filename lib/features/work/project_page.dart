import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/content/profile.dart';
import '../../core/content/projects.dart';
import '../../core/layout/responsive.dart';
import '../../core/theme/palette.dart';
import '../../core/theme/typography.dart';
import '../../core/widgets/pressable.dart';
import '../../core/widgets/reveal.dart';
import '../home/sections/footer_section.dart';
import 'project_visual.dart';

class ProjectPage extends StatelessWidget {
  const ProjectPage({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final next = Projects.next(project);
    return Scaffold(
      backgroundColor: p.bg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Frame(
              child: Padding(
                padding: const EdgeInsets.only(top: 28),
                child: Row(
                  children: [
                    TextLink(label: 'All work', onTap: () => context.go('/')),
                    const Spacer(),
                    Text(Profile.name, style: Typo.display(p, 22)),
                  ],
                ),
              ),
            ),
            Frame(
              child: Padding(
                padding: const EdgeInsets.only(top: 72, bottom: 96),
                child: LayoutBuilder(
                  builder: (context, c) {
                    final stacked = c.maxWidth < 900;
                    final intro = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.number.toString().padLeft(2, '0'),
                          style: Typo.label(p, color: p.accent, size: 14),
                        ),
                        const SizedBox(height: 14),
                        Text(project.title,
                            style: Typo.display(p, stacked ? 56 : 96, height: 1.0)),
                        const SizedBox(height: 16),
                        Text('${project.category}. ${project.platforms}.',
                            style: Typo.label(p, size: 14)),
                        const SizedBox(height: 28),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 520),
                          child: Text(project.summary,
                              style: Typo.body(p, size: 19)),
                        ),
                        const SizedBox(height: 18),
                        Text(project.role,
                            style: Typo.body(p, size: 16, color: p.text)),
                      ],
                    );
                    final plate = Container(
                      height: stacked ? 460 : 640,
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
                              height: stacked ? 340 : 520,
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
                        children: [intro, const SizedBox(height: 40), plate],
                      );
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(flex: 5, child: Padding(
                          padding: const EdgeInsets.only(right: 56),
                          child: intro,
                        )),
                        Expanded(flex: 6, child: plate),
                      ],
                    );
                  },
                ),
              ),
            ),
            Frame(
              child: Column(
                children: [
                  _Block(title: 'The problem', body: project.problem),
                  _Block(title: 'My contribution', body: project.contribution),
                  _Block(title: 'Approach', body: project.approach),
                  _Block(
                    title: 'Technology',
                    body: project.technologies.join(', '),
                  ),
                  if (project.outcome != null)
                    _Block(title: 'Outcome', body: project.outcome!),
                  Container(height: 1, color: p.border),
                ],
              ),
            ),
            Frame(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 64),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Next project', style: Typo.label(p)),
                          const SizedBox(height: 8),
                          Pressable(
                            label: 'Next project, ${next.title}',
                            onTap: () => context.go('/work/${next.id}'),
                            builder: (context, on) => Text(
                              next.title,
                              style: Typo.display(p, 56,
                                  color: on ? p.accent : p.text),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const FooterSection(),
          ],
        ),
      ),
    );
  }
}

class _Block extends StatelessWidget {
  const _Block({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Reveal(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 40),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: p.border)),
        ),
        child: LayoutBuilder(
          builder: (context, c) {
            final stacked = c.maxWidth < 900;
            final head = Text(title, style: Typo.display(p, stacked ? 34 : 40));
            final text = Text(body, style: Typo.body(p, size: 18));
            if (stacked) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [head, const SizedBox(height: 14), text],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 5, child: head),
                const SizedBox(width: 48),
                Expanded(flex: 6, child: text),
              ],
            );
          },
        ),
      ),
    );
  }
}
