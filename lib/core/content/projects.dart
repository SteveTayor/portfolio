class Project {
  const Project({
    required this.id,
    required this.title,
    required this.category,
    required this.platforms,
    required this.summary,
    required this.role,
    required this.problem,
    required this.contribution,
    required this.approach,
    required this.technologies,
    required this.images,
    this.outcome,
  });

  final String id;
  final String title;
  final String category;
  final String platforms;
  final String summary;
  final String role;
  final String problem;
  final String contribution;
  final String approach;
  final List<String> technologies;

  /// Real screenshots, first one is the cover.
  final List<String> images;

  /// Only ever a verified outcome. Null when nothing is confirmed.
  final String? outcome;
}

List<String> _shots(String id, int count) => [
      for (var i = 1; i <= count; i++) 'assets/projects/$id/$i.webp',
    ];

abstract final class Projects {
  /// Projects with screenshots, in display order.
  static final List<Project> shown =
      all.where((p) => p.images.isNotEmpty).toList();

  static Project byId(String? id) =>
      shown.firstWhere((p) => p.id == id, orElse: () => shown.first);

  static Project next(Project current) {
    final i = shown.indexWhere((p) => p.id == current.id);
    return shown[(i + 1) % shown.length];
  }

  static final List<Project> all = [
    Project(
      id: 'bundlegram',
      title: 'Bundlegram',
      category: 'Fintech and Payments',
      platforms: 'iOS and Android, live in production',
      summary:
          'Sole architect and developer of a live fintech payment platform '
          'covering payments, wallets, transactions, airtime and data '
          'services.',
      role: 'Flutter Mobile Architect',
      problem:
          'A fintech payment product needed a complete cross platform '
          'application: wallet management, transactions, airtime and data '
          'services, and a dual role system for users and agents, shipped and '
          'maintainable in production.',
      contribution:
          'Designed the system architecture and built the full application '
          'with BLoC state management across feature modules. Integrated '
          'third party REST APIs with JWT token management and refresh flows, '
          'plus real time transaction sync over WebSocket for live wallet '
          'updates. Built interactive financial dashboards and animated '
          'transaction feeds with CustomPainter and AnimationController, and '
          'architected dual role onboarding with BVN and email verification, '
          'KYC and encrypted wallet management.',
      approach:
          'Feature first architecture with modular feature modules, BLoC for '
          'predictable state, DevTools profiling to remove unnecessary widget '
          'rebuilds and improve cold start time, and continuous delivery '
          'pipelines for automated builds, testing and release to both '
          'platforms.',
      technologies: [
        'Flutter',
        'Dart',
        'BLoC',
        'REST APIs',
        'WebSocket',
        'JWT',
        'Firebase',
        'Secure Storage',
      ],
      images: _shots('bundlegram', 6),
      outcome: 'Live on the App Store and Google Play.',
    ),
    Project(
      id: 'medherence',
      title: 'Medherence',
      category: 'Digital Health',
      platforms: 'iOS and Android, deployed to both stores',
      summary:
          'Lead developer of a digital health platform aligned with HIPAA: '
          'medication adherence, reminders and clinical data visualisation.',
      role: 'Lead Flutter Developer',
      problem:
          'A digital health platform needed a maintainable Flutter '
          'application for medication adherence: animated clinical timelines, '
          'time critical patient reminders, and strict protection of '
          'sensitive health data.',
      contribution:
          'Architected the complete application using Clean Architecture, '
          'separating data, domain and presentation layers. Built animated '
          'medication timelines, interactive adherence dashboards and custom '
          'painted progress indicators. Engineered a background service '
          'reminder engine using Flutter Local Notifications and Alarm '
          'Manager, and implemented data handling aligned with HIPAA through '
          'encrypted local storage, access control and strict clinical data '
          'models.',
      approach:
          'Clean Architecture for modularity and testability, Riverpod for '
          'state management, encrypted local storage through Flutter Secure '
          'Storage, and a crash monitoring and error logging pipeline to '
          'shorten debugging cycles and improve production stability.',
      technologies: [
        'Flutter',
        'Dart',
        'Clean Architecture',
        'Riverpod',
        'Secure Storage',
        'Local Notifications',
        'Alarm Manager',
      ],
      images: _shots('medherence', 6),
      outcome: 'Deployed to the App Store and Google Play.',
    ),
    Project(
      id: 'tradelenda',
      title: 'TradeLenda',
      category: 'Fintech, Authentication and KYC',
      platforms: 'iOS and Android, live application',
      summary:
          'Implemented the Firebase Authentication workflow and loan '
          'application flows in a live fintech app, including liveness '
          'detection for KYC.',
      role: 'Mobile Developer (Flutter), Contract',
      problem:
          'A live fintech application needed its user authentication '
          'experience built, loan application and investment workflows '
          'implemented, and identity verification strengthened against '
          'fraud.',
      contribution:
          'Implemented the Firebase Authentication workflow, contributing to '
          'the sign in and authentication experience. Built the interface '
          'workflows for loan applications and investment dashboards, and '
          'integrated a liveness detection API into KYC onboarding as a '
          'background service component to support fraud prevention and '
          'identity verification.',
      approach:
          'Firebase Authentication for the identity layer, background service '
          'integration for the liveness API, and DevTools profiling to reduce '
          'jank on low end Android devices.',
      technologies: [
        'Flutter',
        'Firebase Authentication',
        'REST APIs',
        'KYC and Liveness API',
      ],
      images: _shots('tradelenda', 4),
    ),
    Project(
      id: 'doorbell',
      title: 'Doorbell',
      category: 'Video and Audio Calling',
      platforms: 'Cross platform mobile',
      summary:
          'A calling app built around a personal QR code: share it, and '
          'anyone who scans it can start a call with you.',
      role: 'Mobile Developer, DoWell UX Living Lab',
      problem:
          'Starting a call usually means exchanging contact details first. '
          'The app lets a person share a personal QR code so that others can '
          'start a call instantly.',
      contribution:
          'Built the WebSocket based signalling for the video and audio call '
          'flow, a QR scanner with CustomPainter overlays, Firebase '
          'integration, and automated end to end testing pipelines.',
      approach:
          'WebSocket signalling for call setup, QR codes for connecting '
          'people, and Firebase services for supporting functionality.',
      technologies: [
        'Flutter',
        'WebSocket',
        'QR scanning',
        'CustomPainter',
        'Firebase',
      ],
      images: _shots('doorbell', 5),
    ),
    Project(
      id: 'musicchatroom',
      title: 'Music Chat Room',
      category: 'Real time Audio and Social',
      platforms: 'Cross platform mobile',
      summary:
          'Synchronised audio streaming with multi user chat sessions, built '
          'for low latency on ordinary connections.',
      role: 'Mobile Developer',
      problem:
          'A social audio product needed synchronised music playback across '
          'many concurrent users, with chat, without excessive latency or '
          'data usage.',
      contribution:
          'Built synchronised audio streaming with multi user sessions, using '
          'lazy loading and asset caching to keep latency low on ordinary '
          'connections.',
      approach:
          'Firebase Firestore and Cloud Functions for session state and '
          'signalling, WebSocket transport, and lazy loading with asset '
          'caching for low latency playback.',
      technologies: [
        'Flutter',
        'Firebase Firestore',
        'Cloud Functions',
        'WebSocket',
      ],
      images: _shots('musicchatroom', 1),
    ),
    // Add screenshots under assets/projects/legalzard and list them in
    // pubspec.yaml, then set images: _shots('legalzard', n) to show this card.
    const Project(
      id: 'legalzard',
      title: 'Legalzard',
      category: 'Developer Tooling',
      platforms: 'Cross platform mobile',
      summary:
          'A software license comparison tool built on complex API '
          'integration, with a metrics module and user feedback after each '
          'comparison.',
      role: 'Mobile Developer',
      problem:
          'Developers and teams needed a mobile way to compare software '
          'licenses and understand the differences between them.',
      contribution:
          'Built the license comparison workflow on complex REST API '
          'integration, and implemented the metrics module and user feedback '
          'flow that follow a comparison.',
      approach:
          'BLoC state management for the comparison flows, structured REST '
          'API integration, and Firebase services for supporting '
          'functionality.',
      technologies: ['Flutter', 'BLoC', 'REST APIs', 'Firebase'],
      images: <String>[],
    ),
  ];
}
