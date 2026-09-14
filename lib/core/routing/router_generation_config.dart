import 'package:go_router/go_router.dart';
import 'package:workwise/core/routing/app_routes.dart';
import 'package:workwise/core/routing/page_transition.dart';
import 'package:workwise/features/tasks/presentation/screens/tasks_screen.dart';

class RouterGenerationConfig {
  static GoRouter goRouter = GoRouter(
    initialLocation: AppRoutes.tasksScreen,
    routes: [
      GoRoute(
        name: AppRoutes.tasksScreen,
        path: AppRoutes.tasksScreen,
        pageBuilder: (context, state) =>
            slideTransitionPage(state: state, child: const TasksScreen()),
      ),
    ],
  );
}
