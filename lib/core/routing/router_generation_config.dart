
// ignore_for_file: unused_import

import 'package:go_router/go_router.dart';
import 'package:workwise/core/routing/app_routes.dart';
import 'package:workwise/core/routing/page_transition.dart';
import 'package:workwise/features/auth/fingerprint/presentation/screens/finger_print_screen.dart';
import 'package:workwise/features/auth/login/presentation/screens/login_screen.dart';
import 'package:workwise/features/splash/presentation/screens/splash_screen.dart';

import 'package:go_router/go_router.dart';
import 'package:workwise/core/routing/app_routes.dart';
import 'package:workwise/core/routing/page_transition.dart';
import 'package:workwise/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:workwise/features/tasks/presentation/screens/tasks_screen.dart';

class RouterGenerationConfig {
  static GoRouter goRouter = GoRouter(
    initialLocation: AppRoutes.splashScreen,
    routes: [
      GoRoute(
        name: AppRoutes.splashScreen,
        path: AppRoutes.splashScreen,
        pageBuilder: (context, state) => slideTransitionPage(
          state: state,
          child: const SplashScreen(),
        ),
      ),
      GoRoute(
        name: AppRoutes.loginScreen,
        path: AppRoutes.loginScreen,
        pageBuilder: (context, state) => slideTransitionPage(
          state: state,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        name: AppRoutes.fingerprintScreen,
        path: AppRoutes.fingerprintScreen,
        pageBuilder: (context, state) => slideTransitionPage(
          state: state,
          child: const FingerPrintScreen(),
        ),
      ),
     
        name: AppRoutes.signInScreen,
        path: AppRoutes.signInScreen,
        pageBuilder: (context, state) =>
            slideTransitionPage(state: state, child: const SignInScreen()),
      ),

      GoRoute(
        name: AppRoutes.tasksScreen,
        path: AppRoutes.tasksScreen,
        pageBuilder: (context, state) =>
            slideTransitionPage(state: state, child: const TasksScreen()),
      ),
    ],
  );
}
