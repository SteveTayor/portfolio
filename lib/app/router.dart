import 'package:go_router/go_router.dart';
import '../core/projects/project_data.dart';
import '../core/projects/project_model.dart';
import '../features/presentation/projects/screens/project_details.dart';

GoRouter buildRouter() {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/projects/:id',
        name: 'project',
        builder: (context, state) {
          final id = state.pathParameters['id'];
          final Project project = kProjects.firstWhere(
            (p) => p.id == id,
            orElse: () => kProjects.first,
          );
          return ProjectDetailPage(project: project);
        },
      ),
    ],
  );
}
