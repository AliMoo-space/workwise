import 'package:go_router/go_router.dart';
import 'package:workwise/core/routing/app_routes.dart';
import 'package:workwise/core/routing/page_transition.dart';
import 'package:workwise/features/attendance/presentation/screens/attendance_screen.dart';
import 'package:workwise/features/auth/fingerprint/presentation/screens/finger_print_screen.dart';
import 'package:workwise/features/auth/forgot_password/presentation/screens/otp_verification_screen.dart';
import 'package:workwise/features/auth/login/presentation/screens/login_screen.dart';
import 'package:workwise/features/auth/reset_password/presentation/screens/create_new_passwors_screen.dart';
import 'package:workwise/features/home/presentation/screens/home_screen.dart';
import 'package:workwise/features/main/presentation/screens/main_screen.dart';
import 'package:workwise/features/attendance/presentation/screens/map_screen.dart';
import 'package:workwise/features/profile/presentation/screen/profile_page.dart';
import 'package:workwise/features/performance/presentation/screens/performance_screen.dart';
import 'package:workwise/features/setting/presentation/screens/settings_screen.dart';
import 'package:workwise/features/splash/presentation/screens/splash_screen.dart';
import 'package:workwise/features/tasks/presentation/screens/tasks_screen.dart';

class RouterGenerationConfig {
  static GoRouter goRouter = GoRouter(
    initialLocation: AppRoutes.splashScreen,
    routes: [
      GoRoute(
        name: AppRoutes.mainScreen,
        path: AppRoutes.mainScreen,
        pageBuilder: (context, state) =>
            slideTransitionPage(state: state, child: const MainScreen()),
      ),
      GoRoute(
        name: AppRoutes.splashScreen,
        path: AppRoutes.splashScreen,
        pageBuilder: (context, state) =>
            noTransitionPage(state: state, child: const SplashScreen()),
      ),
      GoRoute(
        name: AppRoutes.loginScreen,
        path: AppRoutes.loginScreen,
        pageBuilder: (context, state) =>
            slideTransitionPage(state: state, child: const LoginScreen()),
      ),
      GoRoute(
        name: AppRoutes.otpVerificationScreen,
        path: AppRoutes.otpVerificationScreen,
        pageBuilder: (context, state) {
          final email = state.extra as String? ?? '';

          return slideTransitionPage(
            state: state,
            child: OtpVerificationScreen(email: email),
          );
        },
      ),
      GoRoute(
        name: AppRoutes.createNewPasswordScreen,
        path: AppRoutes.createNewPasswordScreen,
        pageBuilder: (context, state) {
          final email = state.extra as String? ?? '';

          return slideTransitionPage(
            state: state,
            child: CreateNewPasswordScreen(email: email),
          );
        },
      ),
      GoRoute(
        name: AppRoutes.fingerprintScreen,
        path: AppRoutes.fingerprintScreen,
        pageBuilder: (context, state) =>
            slideTransitionPage(state: state, child: const FingerPrintScreen()),
      ),
      GoRoute(
        name: AppRoutes.profilePage,
        path: AppRoutes.profilePage,
        pageBuilder: (context, state) {
          return slideTransitionPage(state: state, child: ProfilePage());
        },
      ),
      GoRoute(
        name: AppRoutes.homeScreen,
        path: AppRoutes.homeScreen,
        pageBuilder: (context, state) =>
            slideTransitionPage(state: state, child: const HomeScreen()),
      ),
      GoRoute(
        name: AppRoutes.tasksScreen,
        path: AppRoutes.tasksScreen,
        pageBuilder: (context, state) =>
            slideTransitionPage(state: state, child: TasksScreen()),
      ),
      GoRoute(
        name: AppRoutes.attendanceScreen,
        path: AppRoutes.attendanceScreen,
        pageBuilder: (context, state) {
          return slideTransitionPage(
            state: state,
            child: const AttendanceScreen(),
          );
        },
      ),
      GoRoute(
        name: AppRoutes.mapScreen,
        path: AppRoutes.mapScreen,
        pageBuilder: (context, state) =>
            slideTransitionPage(state: state, child: const MapScreen()),
      ),
      GoRoute(
        name: AppRoutes.performanceScreen,
        path: AppRoutes.performanceScreen,
        pageBuilder: (context, state) {
          return slideTransitionPage(
            state: state,
            child: const PerformanceScreen(),
          );
        },
      ),
      GoRoute(
        name: AppRoutes.settingsScreen,
        path: AppRoutes.settingsScreen,
        pageBuilder: (context, state) =>
            slideTransitionPage(state: state, child: const SettingsScreen()),
      ),
    ],
  );
}
