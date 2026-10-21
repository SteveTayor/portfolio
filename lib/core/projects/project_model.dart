class Project {
  final String id;
  final int number;
  final String title;
  final String category;
  final String platforms;
  final String summary;
  final String role;
  final String problem;
  final String contribution;
  final String approach;
  final List<String> technologies;

  /// Only ever a verified outcome. Null when nothing is confirmed.
  final String? outcome;
  final String? liveUrl;
  final String? repositoryUrl;

  /// Which abstract visual composition the carousel renders for this project.
  final ProjectVisualStyle visualStyle;

  const Project({
    required this.id,
    required this.number,
    required this.title,
    required this.category,
    required this.platforms,
    required this.summary,
    required this.role,
    required this.problem,
    required this.contribution,
    required this.approach,
    required this.technologies,
    required this.visualStyle,
    this.outcome,
    this.liveUrl,
    this.repositoryUrl,
  });
}

enum ProjectVisualStyle {
  fintechPhone,
  healthDashboard,
  authFlow,
  realtimeAudio,
  licenseTool,
}
