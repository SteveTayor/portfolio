import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/content/profile.dart';
import '../../core/content/projects.dart';
import '../../core/layout/responsive.dart';
import '../../core/theme/palette.dart';
import '../../core/theme/typography.dart';
import '../../core/widgets/pressable.dart';
import '../../core/widgets/reveal.dart';
import '../../core/widgets/stage.dart';
import '../home/sections/footer_section.dart';
import 'project_overlay.dart';
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
                padding: const EdgeInsets.only(top: 64, bottom: 72),
                child: LayoutBuilder(
                  builder: (context, c) {
                    final stacked = c.maxWidth < 900;
                    final intro = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(project.category,
                            style: Typo.label(p, color: p.accent, size: 14)),
                        const SizedBox(height: 14),
                        Semantics(
                          header: true,
                          child: Text(
                            project.title,
                            style: Typo.display(p, stacked ? 48 : 68, height: 1.02),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(project.platforms, style: Typo.label(p, size: 14)),
                        const SizedBox(height: 26),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 520),
                          child: Text(project.summary,
                              style: Typo.body(p, size: 19, height: 1.45)),
                        ),
                        const SizedBox(height: 18),
                        Text(project.role,
                            style: Typo.body(p, size: 16, color: p.text)),
                      ],
                    );
                    final plate = Container(
                      height: stacked ? 460 : 620,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: p.surface,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: p.border),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: ProjectThumb(project: project),
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
                        Expanded(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 56),
                            child: intro,
                          ),
                        ),
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
                  _Block(title: 'Technology', body: project.technologies.join(', ')),
                  if (project.outcome != null)
                    _Block(title: 'Outcome', body: project.outcome!),
                  Container(height: 1, color: p.border),
                ],
              ),
            ),
            Frame(
              child: Padding(
                padding: const EdgeInsets.only(top: 72, bottom: 24),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: [
                      for (var i = 0; i < project.images.length; i++)
                        Pressable(
                          label: 'Open screen ${i + 1}',
                          onTap: () => showProjectOverlay(
                            context, project, initialIndex: i),
                          builder: (context, on) => AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: on ? 1 : 0.92,
                            child: PhoneShot(asset: project.images[i], width: 170),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Frame(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 72),
                child: Align(
                  alignment: Alignment.centerLeft,
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
                          style: Typo.display(p, 44, color: on ? p.accent : p.text),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const StageBlock(child: FooterSection()),
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
            final head = Semantics(
              header: true,
              child: Text(title, style: Typo.display(p, stacked ? 28 : 34)),
            );
            final text = Text(body, style: Typo.body(p, size: 18, height: 1.5));
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


/// Explicit fallback for an unknown project URL. Never display another
/// project's content for a link that cannot be resolved.
class ProjectNotFoundPage extends StatelessWidget {
  const ProjectNotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Scaffold(
      backgroundColor: p.bg,
      body: Center(
        child: Frame(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Project not found',
                    style: Typo.label(p, color: p.accent, size: 14),
                  ),
                  const SizedBox(height: 18),
                  Semantics(
                    header: true,
                    child: Text(
                      'This project link may be outdated.',
                      style: Typo.display(p, 38, height: 1.08),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'The project could not be matched to a published case study.',
                    style: Typo.body(p, size: 17),
                  ),
                  const SizedBox(height: 28),
                  PrimaryButton(
                    label: 'Back to portfolio',
                    onTap: () => context.go('/'),
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
