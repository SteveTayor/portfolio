class Role {
  const Role(this.title, this.org, this.period, this.summary);
  final String title;
  final String org;
  final String period;
  final String summary;
}

class Note {
  const Note(this.title, this.body, [this.tags = const <String>[]]);
  final String title;
  final String body;
  final List<String> tags;
}

abstract final class Story {
  /// Words for the moving technology bands.
  static const List<String> bandOne = [
    'Flutter', 'Dart', 'BLoC', 'Riverpod', 'Clean Architecture', 'CustomPainter',
  ];
  static const List<String> bandTwo = [
    'REST APIs', 'WebSocket', 'Firebase', 'JWT', 'Secure Storage', 'Continuous delivery',
  ];

  static const String aboutOne =
      'I approach development as a product problem as much as an engineering '
      'problem. A good feature needs to be understandable to its users, fit '
      'into the existing architecture, and behave reliably across real '
      'devices and network conditions.';

  static const String aboutTwo =
      'My work centres on Flutter applications, backend integrations, '
      'authentication flows, state management, and extending applications '
      'that are already in production. I value clear structure, maintainable '
      'code, and practical solutions that solve the actual problem.';

  static const List<Note> principles = [
    Note('Build for real use',
        'Features should work beyond the ideal demo scenario.'),
    Note('Respect the existing system',
        'New functionality must fit the architecture and avoid regressions.'),
    Note('Make complexity manageable',
        'Readable code, clear state and predictable behaviour keep products '
            'easy to maintain.'),
  ];

  static const List<Note> expertise = [
    Note(
      'Mobile application development',
      'Flutter and Dart for iOS and Android, with reusable widgets and '
          'component design, state management, responsive layouts, '
          'navigation and routing, and theme systems that keep the interface '
          'consistent.',
      ['Flutter', 'Dart', 'BLoC', 'Riverpod', 'go_router', 'Clean Architecture', 'CustomPainter', 'AnimationController'],
    ),
    Note(
      'Backend integration and services',
      'REST APIs and JSON, Firebase Authentication, session management, and '
          'the states a real product needs: loading, error, empty and retry, '
          'plus secure local storage and network connectivity handling.',
      ['REST APIs', 'WebSocket', 'Firebase Authentication', 'Firestore', 'Cloud Functions', 'JWT', 'Secure Storage', 'Paystack SDK', 'KYC and liveness APIs'],
    ),
    Note(
      'Quality, maintenance and delivery',
      'Debugging existing applications, building new functionality into '
          'shipped products, resolving interface and state issues, handling '
          'asynchronous data, and Git based development with testing across '
          'supported devices.',
      ['Git', 'DevTools profiling', 'Unit and widget testing', 'Continuous delivery', 'Local Notifications', 'Alarm Manager'],
    ),
  ];

  static const List<Role> roles = [
    Role(
      'Flutter Mobile Architect',
      'Bundlegram, fintech payment platform',
      'June 2025 to September 2026',
      'Sole architect and developer of a live fintech payment platform: '
          'system architecture, BLoC state management across feature modules, '
          'REST and WebSocket integrations, dual role onboarding with KYC, '
          'and continuous delivery to both stores.',
    ),
    Role(
      'Mobile Developer (Flutter), Contract',
      'TradeLenda, fintech, Lagos',
      'June 2025 to September 2025',
      'Implemented the Firebase Authentication workflow, loan application and '
          'investment workflows, and integrated a liveness detection API into '
          'KYC onboarding. Profiled and reduced jank on low end Android '
          'devices.',
    ),
    Role(
      'Lead Flutter Developer',
      'Medherence, digital health platform',
      'January 2025 to June 2025',
      'Architected a health application aligned with HIPAA using Clean '
          'Architecture: animated medication timelines, a background service '
          'reminder engine, encrypted local storage and crash monitoring. '
          'Deployed to the App Store and Google Play.',
    ),
    Role(
      'Mobile Developer',
      'DoWell UX Living Lab',
      'November 2022 to December 2024',
      'Built WebSocket based signalling for a video and audio call '
          'application, a QR scanner with CustomPainter overlays and Firebase '
          'integration, and automated end to end testing pipelines.',
    ),
    Role(
      'Mobile Developer',
      'DUKA Nigeria',
      'February 2022 to November 2022',
      'Integrated the Paystack payment SDK into a marketplace app with '
          'secure transaction flows and encrypted session management.',
    ),
  ];

  static const List<Note> process = [
    Note('Understand',
        'Clarify the requirement, the existing structure, the problem the '
            'user has and the acceptance criteria before building.'),
    Note('Plan',
        'Choose an approach that fits the architecture, name the '
            'dependencies, and decide how errors and edge cases are handled.'),
    Note('Build and verify',
        'Implement the feature, connect the services, handle loading and '
            'error states, and test the behaviour that matters.'),
    Note('Refine and deliver',
        'Review maintainability, responsiveness, regression risk and the '
            'quality of the final experience.'),
  ];
}
