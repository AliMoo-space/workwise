import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/feedback/app_loader.dart';
import 'package:workwise/core/design_system/widgets/media/app_assets.dart';
import 'package:workwise/core/design_system/widgets/media/app_image.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';
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
            context.go(AppRoutes.homeScreen);
          }
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.primary,
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                AppImage(
                  assetPath: getImagePath('logo2'),
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
                const Gap(AppSpacing.space32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppLoader(
                      size: 16.w,
                      strokeWidth: 2.w,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    const Gap(AppSpacing.space12),
                    AppText(
                      context.l10n.loading,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                    ),
                  ],
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