import 'package:flutter/material.dart';
import '../../../../../core/responsive/responsive.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/text_styles.dart';

class ProcessSection extends StatelessWidget {
  const ProcessSection({super.key});

  static const _stages = [
    (
      '01',
      'Understand',
      'Clarify the requirement, the existing application structure, the '
          "user's problem, and the acceptance criteria before implementing "
          'a solution.',
    ),
    (
      '02',
      'Plan',
      'Choose an implementation approach that fits the application '
          'architecture, identify dependencies, and decide how errors and '
          'edge cases should be handled.',
    ),
    (
      '03',
      'Build & verify',
      'Implement the feature, connect relevant services, handle loading '
          'and error states, and test the behaviour that matters.',
    ),
    (
      '04',
      'Refine & deliver',
      'Review maintainability, responsiveness, regression risks, and the '
          'quality of the final user experience.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final mobile = Responsive.isMobile(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: Responsive.sectionSpacing(context),
        horizontal: Responsive.sidePadding(context),
      ),
      child: Center(
        child: SizedBox(
          width: Responsive.contentWidth(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'From requirement to reliable release.',
                style: AppTextStyles.sectionTitle(context, c.textPrimary),
              ),
              const SizedBox(height: 48),
              if (mobile)
                Column(
                  children: [
                    for (var i = 0; i < _stages.length; i++)
                      _Stage(
                        stage: _stages[i],
                        isLast: i == _stages.length - 1,
                        vertical: true,
                      ),
                  ],
                )
              else
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (var i = 0; i < _stages.length; i++)
                        Expanded(
                          child: _Stage(
                            stage: _stages[i],
                            isLast: i == _stages.length - 1,
                            vertical: false,
                          ),
                        ),
                    ],
                  ),
                ),
              const SizedBox(height: 12),
              Text(
                'The shape of the process adapts to each engagement  this '
                'is the default, not a rigid contract.',
                style: AppTextStyles.body(
                  context,
                  c.textMuted,
                ).copyWith(fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Stage extends StatefulWidget {
  final (String, String, String) stage;
  final bool isLast;
  final bool vertical;
  const _Stage({
    required this.stage,
    required this.isLast,
    required this.vertical,
  });

  @override
  State<_Stage> createState() => _StageState();
}

class _StageState extends State<_Stage> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final number = AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 160),
      style: AppTextStyles.projectNumber(
        _hovered ? c.accentTeal : c.border,
      ).copyWith(fontSize: 34),
      child: Text(widget.stage.$1),
    );

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        number,
        const SizedBox(height: 12),
        Text(
          widget.stage.$2,
          style: AppTextStyles.body(
            context,
            c.textPrimary,
          ).copyWith(fontWeight: FontWeight.w700, fontSize: 16.5),
        ),
        const SizedBox(height: 8),
        Text(
          widget.stage.$3,
          style: AppTextStyles.body(context, c.textSecondary),
        ),
      ],
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: FocusableActionDetector(
        onShowFocusHighlight: (f) => setState(() => _hovered = f),
        child: widget.vertical
            ? IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          margin: const EdgeInsets.only(top: 12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _hovered ? c.accentTeal : c.border,
                          ),
                        ),
                        if (!widget.isLast)
                          Expanded(
                            child: Container(
                              width: 1,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              color: c.border,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 32),
                        child: body,
                      ),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: EdgeInsets.only(
                  right: widget.isLast ? 0 : 36,
                  bottom: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 1,
                      color: c.border,
                      margin: const EdgeInsets.only(bottom: 20),
                    ),
                    body,
                  ],
                ),
              ),
      ),
    );
  }
}
