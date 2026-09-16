import 'package:go_router/go_router.dart';
import 'package:workwise/core/routing/app_routes.dart';
import 'package:workwise/core/routing/page_transition.dart';

import 'package:workwise/features/home/presentation/screens/home_screen.dart';
import 'package:workwise/features/main/presentation/screens/main_screen.dart';
import 'package:workwise/features/tasks/presentation/screens/tasks_screen.dart';

class RouterGenerationConfig {
  static GoRouter goRouter = GoRouter(
    initialLocation: AppRoutes.mainScreen,
    routes: [
      // GoRoute(
      //   name: AppRoutes.signInScreen,
      //   path: AppRoutes.signInScreen,
      //   pageBuilder: (context, state) =>
      //       slideTransitionPage(
      //         state: state,
      //         child: const SignInScreen(),
      //       ),
      // ),
      GoRoute(
        name: AppRoutes.mainScreen,
        path: AppRoutes.mainScreen,
        pageBuilder: (context, state) {
          return slideTransitionPage(state: state, child: const MainScreen());
        },
      ),

      GoRoute(
        name: AppRoutes.homeScreen,
        path: AppRoutes.homeScreen,
        pageBuilder: (context, state) {
          return slideTransitionPage(state: state, child: const HomeScreen());
        },
      ),

      GoRoute(
        name: AppRoutes.tasksScreen,
        path: AppRoutes.tasksScreen,
        pageBuilder: (context, state) {
          return slideTransitionPage(state: state, child: const TasksScreen());
        },
      ),
    ],
  );
}
