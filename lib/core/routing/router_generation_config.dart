import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workwise/core/routing/app_routes.dart';
import 'package:workwise/core/routing/page_transition.dart';
import 'package:workwise/features/attendance/presentation/screens/attendance_screen.dart';
import 'package:workwise/features/attendance/presentation/cubit/attendance_cubit.dart';
import 'package:workwise/features/attendance/presentation/cubit/attendance_history_cubit.dart';
import 'package:workwise/core/services/service_locator.dart';
import 'package:workwise/features/auth/fingerprint/presentation/screens/finger_print_screen.dart';
import 'package:workwise/features/auth/forgot_password/presentation/screens/otp_verification_screen.dart';
import 'package:workwise/features/auth/login/presentation/screens/login_screen.dart';
import 'package:workwise/features/auth/reset_password/presentation/screens/create_new_passwors_screen.dart';
import 'package:workwise/features/home/presentation/screens/home_screen.dart';
import 'package:workwise/features/leave/presentation/widget/leavehistoryscreen.dart';
import 'package:workwise/features/main/presentation/screens/main_screen.dart';
import 'package:workwise/features/attendance/presentation/screens/map_screen.dart';
import 'package:workwise/features/performance/presentation/screens/goal_details_screen.dart';
import 'package:workwise/features/performance/presentation/screens/goalsviewallscreen.dart';
import 'package:workwise/features/profile/presentation/screen/profile_page.dart';
import 'package:workwise/features/performance/presentation/screens/performance_screen.dart';
import 'package:workwise/features/setting/presentation/screens/settings_screen.dart';
import 'package:workwise/features/splash/presentation/screens/splash_screen.dart';
import 'package:workwise/features/tasks/presentation/screens/tasks_screen.dart';
import 'package:workwise/features/notification/presentation/cubit/notification_cubit.dart';
import 'package:workwise/features/notification/presentation/screens/notification_screen.dart';

class RouterGenerationConfig {
  static GoRouter goRouter = GoRouter(
    initialLocation: AppRoutes.mainScreen,
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
            child: MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => sl<AttendanceCubit>()),
                BlocProvider(create: (_) => sl<AttendanceHistoryCubit>()),
              ],
              child: const AttendanceScreen(),
            ),
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
        name: 'goalDetailsScreen',
        path: '${AppRoutes.goalDetailsScreen}/:goalId',
        pageBuilder: (context, state) {
          final goalId = int.parse(state.pathParameters['goalId']!);

          return slideTransitionPage(
            state: state,
            child: GoalDetailsScreen(goalId: goalId),
          );
        },
      ),

      GoRoute(
        name: AppRoutes.goalViewAll,
        path: AppRoutes.goalViewAll,
        pageBuilder: (context, state) => slideTransitionPage(
          state: state,
          child: const GoalsViewAllScreen(),
        ),
      ),

      GoRoute(
        name: AppRoutes.settingsScreen,
        path: AppRoutes.settingsScreen,
        pageBuilder: (context, state) =>
            slideTransitionPage(state: state, child: const SettingsScreen()),
      ),
      GoRoute(
        name: AppRoutes.leaveScreen,
        path: AppRoutes.leaveScreen,
        pageBuilder: (context, state) => slideTransitionPage(
          state: state,
          child: const LeaveHistoryScreen(),
        ),
      ),
      GoRoute(
        name: AppRoutes.notificationScreen,
        path: AppRoutes.notificationScreen,
        pageBuilder: (context, state) => slideTransitionPage(
          state: state,
          child: BlocProvider(
            create: (_) => sl<NotificationCubit>(),
            child: const NotificationScreen(),
          ),
        ),
      ),
    ],
  );
}
