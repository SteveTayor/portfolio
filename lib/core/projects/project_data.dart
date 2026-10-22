import 'project_model.dart';

/// Verified project content, separated from layout. Update entries here.
/// Do not add unverified outcomes, clients, or links.
final List<Project> kProjects = [
  Project(
    id: 'bundlegram',
    number: 1,
    title: 'Bundlegram',
    category: 'Fintech / Payments',
    platforms: 'iOS & Android · live in production',
    summary:
        'Sole architect and developer of a live fintech payment platform payments, wallets, transactions, airtime and data services.',
    role: 'Flutter Mobile Architect',
    problem:
        'A fintech payment product needed a complete cross-platform application: wallet management, transactions, airtime and data services, and a dual-role user/agent system  shipped and maintainable in production.',
    contribution:
        'Designed the system architecture and implemented the full application with BLoC state management across feature modules. Integrated third-party REST JSON APIs with JWT token management and refresh flows, plus real-time transaction sync over WebSocket for live wallet updates. Built interactive financial dashboards and animated transaction feeds with CustomPainter and AnimationController, and architected dual-role onboarding with BVN and email verification, KYC and encrypted wallet management.',
    approach:
        'Feature-first architecture with modular feature modules, BLoC for predictable state, DevTools-driven profiling to remove unnecessary widget rebuilds and improve cold-start time, and CI/CD pipelines for automated builds, testing and release to both platforms.',
    technologies: const [
      'Flutter',
      'Dart',
      'BLoC',
      'REST APIs',
      'WebSocket',
      'JWT',
      'Firebase services',
      'Flutter Secure Storage',
      'CI/CD',
    ],
    visualStyle: ProjectVisualStyle.fintechPhone,
    outcome: 'Live on the App Store and Google Play.',
  ),
  Project(
    id: 'medherence',
    number: 2,
    title: 'Medherence',
    category: 'Digital Health',
    platforms: 'iOS & Android · deployed to both stores',
    summary:
        'Lead developer of a HIPAA-aligned digital health platform  medication adherence, reminders and clinical data visualisation.',
    role: 'Lead Flutter Developer',
    problem:
        'A digital health platform needed a maintainable Flutter application for medication adherence: animated clinical timelines, time-critical patient reminders, and strict protection of sensitive health data.',
    contribution:
        'Architected the complete application using Clean Architecture, separating data, domain and presentation layers. Built animated medication timelines, interactive adherence dashboards and custom-painted progress indicators. Engineered a background-service reminder engine using Flutter Local Notifications and Alarm Manager, and implemented HIPAA-aligned data handling with encrypted local storage, access control and strict clinical data models.',
    approach:
        'Clean Architecture for modularity and testability, Riverpod for state management, encrypted local storage via Flutter Secure Storage, and a crash-monitoring and error-logging pipeline to shorten debugging cycles and improve production stability.',
    technologies: const [
      'Flutter',
      'Dart',
      'Clean Architecture',
      'Riverpod',
      'Flutter Secure Storage',
      'Local Notifications',
      'Alarm Manager',
    ],
    visualStyle: ProjectVisualStyle.healthDashboard,
    outcome: 'Deployed to the App Store and Google Play.',
  ),
  Project(
    id: 'tradelenda',
    number: 3,
    title: 'TradeLenda',
    category: 'Fintech / Authentication & KYC',
    platforms: 'iOS & Android · live application',
    summary:
        'Implemented the Firebase Authentication workflow and loan-application UI flows in a live fintech application, including liveness-detection KYC integration.',
    role: 'Mobile Developer (Flutter), Contract',
    problem:
        'A live fintech application needed its user authentication experience built, loan-application and investment UI workflows implemented, and identity verification strengthened against fraud.',
    contribution:
        'Implemented the Firebase Authentication workflow, contributing to the application\'s sign-in and authentication experience. Implemented UI workflows for loan applications and investment dashboards, and integrated a liveness-detection hardware API into KYC onboarding as a background service component to support fraud prevention and identity verification.',
    approach:
        'Firebase Authentication for the identity layer, background-service integration for the liveness API, and DevTools profiling to reduce jank on low-end Android devices.',
    technologies: const [
      'Flutter',
      'Firebase Authentication',
      'REST APIs',
      'KYC / Liveness API',
    ],
    visualStyle: ProjectVisualStyle.authFlow,
  ),
  Project(
    id: 'music-chat-room',
    number: 4,
    title: 'Music & Chat Room',
    category: 'Real-time audio / Social',
    platforms: 'Cross-platform mobile',
    summary:
        'Real-time synchronised audio streaming with multi-user chat sessions, built for low latency on ordinary connections.',
    role: 'Mobile Developer',
    problem:
        'A social audio product needed synchronised music playback across multiple concurrent users, with chat, without excessive latency or data usage.',
    contribution:
        'Built real-time synchronised audio streaming with multi-user sessions, using lazy loading and asset caching to keep latency low on ordinary connections.',
    approach:
        'Firebase Firestore and Cloud Functions for session state and signalling, WebSocket transport, and lazy loading with asset caching for low-latency playback.',
    technologies: const [
      'Flutter',
      'Firebase Firestore',
      'Cloud Functions',
      'WebSocket',
    ],
    visualStyle: ProjectVisualStyle.realtimeAudio,
  ),
  Project(
    id: 'legalzard',
    number: 5,
    title: 'Legalzard',
    category: 'Developer tooling',
    platforms: 'Cross-platform mobile',
    summary:
        'A software-license comparison tool built on complex API integration, with a post-comparison metrics module and user feedback.',
    role: 'Mobile Developer',
    problem:
        'Developers and teams needed a mobile way to compare software licenses and understand metric differences between them.',
    contribution:
        'Built the license comparison workflow on complex REST API integration, and implemented the post-comparison metrics module and user feedback flow.',
    approach:
        'BLoC state management for the comparison flows, structured REST API integration, and Firebase services for supporting functionality.',
    technologies: const ['Flutter', 'BLoC', 'REST API', 'Firebase'],
    visualStyle: ProjectVisualStyle.licenseTool,
  ),
];
