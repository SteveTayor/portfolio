import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../core/content/projects.dart';
import '../features/home/home_page.dart';
import '../features/work/project_page.dart';

GoRouter buildRouter() {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => _fade(state, const HomePage()),
      ),
      GoRoute(
        path: '/work/:id',
        pageBuilder: (context, state) {
          final project = Projects.byId(state.pathParameters['id']);
          if (project == null) {
            return _fade(state, const ProjectNotFoundPage());
          }
          return _fade(state, ProjectPage(project: project));
        },
      ),
    ],
    errorPageBuilder: (context, state) => _fade(state, const HomePage()),
  );
}

CustomTransitionPage<void> _fade(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 360),
    transitionsBuilder: (context, animation, secondary, page) {
      return FadeTransition(opacity: animation, child: page);
    },
  );
}
