import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/media/app_assets.dart';
import 'package:workwise/core/design_system/widgets/media/app_image.dart';
import 'package:workwise/core/routing/app_routes.dart';
import 'package:workwise/features/splash/presentation/logic/splash_cubit.dart';
import 'package:workwise/features/splash/presentation/logic/splash_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        FlutterNativeSplash.remove();
        return SplashCubit()..checkAuthSession();
      },
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is UnauthenticatedState) {
            context.go(AppRoutes.loginScreen);
          } else if (state is AuthenticatedState) {
            context.go(AppRoutes.mainScreen);
          }
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Center(
                  child: AppImage(
                    assetPath: getImagePath('logo2'),
                    width: AppSpacing.space96,
                    height: AppSpacing.space96,
                    fit: BoxFit.contain,
                  ),
                ),
                
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
