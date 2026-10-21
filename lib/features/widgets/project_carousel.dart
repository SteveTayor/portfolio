import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/responsive/responsive.dart';
import '../../core/projects/project_data.dart';
import '../../core/projects/project_model.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/text_styles.dart';
import 'project_visual.dart';

/// Editorial case-study carousel. The active project holds focus with a
/// sliver of the next one visible on wide screens. Visitor-controlled:
/// no autoplay, full keyboard, swipe and control support.
class ProjectCarousel extends StatefulWidget {
  const ProjectCarousel({super.key});

  @override
  State<ProjectCarousel> createState() => _ProjectCarouselState();
}

class _ProjectCarouselState extends State<ProjectCarousel> {
  late final PageController _controller;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      viewportFraction: Responsive.isMobile(context) ? 1.0 : 0.86,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _go(int delta) {
    final target = (_index + delta).clamp(0, kProjects.length - 1);
    if (target == _index) return;
    _controller.animateToPage(
      target,
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
    );
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        _go(1);
        return KeyEventResult.handled;
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        _go(-1);
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final mobile = Responsive.isMobile(context);

    return Focus(
      onKeyEvent: _onKey,
      child: Column(
        children: [
          SizedBox(
            height: mobile ? 640 : 480,
            child: PageView.builder(
              controller: _controller,
              itemCount: kProjects.length,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (context, i) {
                final project = kProjects[i];
                return AnimatedScale(
                  scale: i == _index ? 1.0 : 0.96,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  child: Padding(
                    padding: EdgeInsets.only(right: mobile ? 0 : 32),
                    child: _CarouselCard(project: project, compact: mobile),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 26),
          Row(
            children: [
              _CircleControl(
                icon: Icons.arrow_back,
                enabled: _index > 0,
                onTap: () => _go(-1),
                tooltip: 'Previous project',
              ),
              const SizedBox(width: 10),
              _CircleControl(
                icon: Icons.arrow_forward,
                enabled: _index < kProjects.length - 1,
                onTap: () => _go(1),
                tooltip: 'Next project',
              ),
              const SizedBox(width: 22),
              Expanded(
                child: Row(
                  children: [
                    for (var i = 0; i < kProjects.length; i++)
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _controller.animateToPage(
                            i,
                            duration: const Duration(milliseconds: 380),
                            curve: Curves.easeOutCubic,
                          ),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 240),
                            height: 3,
                            margin: const EdgeInsets.only(right: 6),
                            color: i == _index ? c.accentTeal : c.border,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 22),
              Text(
                '${(_index + 1).toString().padLeft(2, '0')} / '
                '${kProjects.length.toString().padLeft(2, '0')}',
                style: AppTextStyles.meta(c.textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CircleControl extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;
  final String tooltip;
  const _CircleControl({
    required this.icon,
    required this.enabled,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return IconButton.filledTonal(
      onPressed: enabled ? onTap : null,
      icon: Icon(icon, size: 18),
      tooltip: tooltip,
      style: IconButton.styleFrom(
        backgroundColor: c.bgSecondary,
        disabledBackgroundColor: c.bgSecondary.withOpacity(0.5),
        foregroundColor: enabled ? c.textPrimary : c.textMuted,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9),
          side: BorderSide(color: c.border),
        ),
      ),
    );
  }
}

class _CarouselCard extends StatelessWidget {
  final Project project;
  final bool compact;
  const _CarouselCard({required this.project, required this.compact});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    final info = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: compact
          ? MainAxisAlignment.start
          : MainAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              project.number.toString().padLeft(2, '0'),
              style: AppTextStyles.projectNumber(c.accentTeal),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                '${project.category} · ${project.platforms}',
                style: AppTextStyles.meta(c.textMuted),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          project.title,
          style: AppTextStyles.projectTitle(context, c.textPrimary),
        ),
        const SizedBox(height: 12),
        Text(
          project.summary,
          style: AppTextStyles.body(context, c.textSecondary),
        ),
        const SizedBox(height: 14),
        Text(
          'Role — ${project.role}',
          style: AppTextStyles.body(
            context,
            c.textPrimary,
          ).copyWith(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        if (project.outcome != null) ...[
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.check_circle_outline, size: 15, color: c.accentTeal),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  project.outcome!,
                  style: AppTextStyles.body(
                    context,
                    c.textSecondary,
                  ).copyWith(fontSize: 13.5),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final tech in project.technologies.take(6))
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: c.border),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  tech,
                  style: AppTextStyles.meta(
                    c.textSecondary,
                  ).copyWith(fontSize: 11, letterSpacing: 0.3),
                ),
              ),
          ],
        ),
        const SizedBox(height: 22),
        InkWell(
          onTap: () => context.go('/projects/${project.id}'),
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'View case study',
                  style: AppTextStyles.button(c.accentTeal),
                ),
                const SizedBox(width: 6),
                Icon(Icons.arrow_forward, size: 15, color: c.accentTeal),
              ],
            ),
          ),
        ),
      ],
    );

    final visual = ProjectVisual(project: project);

    return Container(
      decoration: BoxDecoration(
        color: c.bgSecondary,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.border),
      ),
      padding: EdgeInsets.all(compact ? 20 : 32),
      child: compact
          ? ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: [
                SizedBox(height: 300, child: visual),
                const SizedBox(height: 24),
                info,
              ],
            )
          : Row(
              children: [
                Expanded(flex: 55, child: visual),
                const SizedBox(width: 36),
                Expanded(flex: 45, child: info),
              ],
            ),
    );
  }
}
