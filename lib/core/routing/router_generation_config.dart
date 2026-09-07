
import 'package:go_router/go_router.dart';
import 'package:workwise/core/routing/app_routes.dart';
import 'package:workwise/core/routing/page_transition.dart';
import 'package:workwise/features/auth/presentation/screens/sign_in_screen.dart';

class RouterGenerationConfig {
  static GoRouter goRouter = GoRouter(
    initialLocation: AppRoutes.signInScreen,
    routes: [
     
      GoRoute(
        name: AppRoutes.signInScreen,
        path: AppRoutes.signInScreen,
        pageBuilder: (context, state) => slideTransitionPage(
          state: state,
          child: const SignInScreen(),
        ),
      ),
      
     
    ],
  );
}
