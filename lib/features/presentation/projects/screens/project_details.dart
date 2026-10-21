import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/projects/project_data.dart';
import '../../../../core/projects/project_model.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../widgets/project_visual.dart';

class ProjectDetailPage extends StatelessWidget {
  final Project project;
  const ProjectDetailPage({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final idx = kProjects.indexWhere((p) => p.id == project.id);
    final prev = idx > 0 ? kProjects[idx - 1] : null;
    final next = idx >= 0 && idx < kProjects.length - 1
        ? kProjects[idx + 1]
        : null;

    Widget block(String label, String body) => Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: AppTextStyles.eyebrow(c.accentTeal)),
          const SizedBox(height: 10),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Text(
              body,
              style: AppTextStyles.body(context, c.textSecondary),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(
          color: c.textPrimary,
          onPressed: () => context.go('/'),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.sidePadding(context),
          vertical: 24,
        ),
        child: Center(
          child: SizedBox(
            width: Responsive.contentWidth(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${project.category} · ${project.platforms}',
                  style: AppTextStyles.meta(c.textMuted),
                ),
                const SizedBox(height: 12),
                Text(
                  project.title,
                  style: AppTextStyles.sectionTitle(context, c.textPrimary),
                ),
                const SizedBox(height: 8),
                Text(
                  'Role — ${project.role}',
                  style: AppTextStyles.body(
                    context,
                    c.textPrimary,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 28),
                SizedBox(height: 400, child: ProjectVisual(project: project)),
                const SizedBox(height: 40),
                block('Overview', project.summary),
                block('Product context', project.problem),
                block('My contribution', project.contribution),
                block('Implementation approach', project.approach),
                if (project.outcome != null)
                  block('Verified outcome', project.outcome!),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final t in project.technologies)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: c.border),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          t,
                          style: AppTextStyles.meta(
                            c.textSecondary,
                          ).copyWith(letterSpacing: 0.4, fontSize: 11.5),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    if (prev != null)
                      TextButton.icon(
                        onPressed: () => context.go('/projects/${prev.id}'),
                        icon: const Icon(Icons.arrow_back, size: 16),
                        label: Text(prev.title),
                      ),
                    const Spacer(),
                    if (next != null)
                      TextButton.icon(
                        onPressed: () => context.go('/projects/${next.id}'),
                        icon: const Icon(Icons.arrow_forward, size: 16),
                        label: Text(next.title),
                      ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
