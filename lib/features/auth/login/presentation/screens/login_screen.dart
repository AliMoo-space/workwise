import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';
import 'package:workwise/core/routing/app_routes.dart';
import 'package:workwise/features/auth/login/logic/login_cubit.dart';
import 'package:workwise/features/auth/login/logic/login_state.dart';
import 'package:workwise/features/auth/login/presentation/widgets/login_form.dart';
import 'package:workwise/features/auth/login/presentation/widgets/login_header_widget.dart';
import 'package:workwise/features/auth/login/presentation/widgets/login_warning_banner.dart';
import 'package:workwise/features/auth/login/presentation/widgets/quick_sign_in_button.dart';
import 'package:workwise/generated/app_localizations.dart';

class LoginScreen extends StatelessWidget {
  final bool isSessionExpired;

  const LoginScreen({super.key, this.isSessionExpired = false});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onSurface,
        body: SafeArea(
          child: BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is LoginSuccessState) {
                context.go(AppRoutes.homeScreen);
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Gap(12.h),
                    LoginHeaderWidget(),
                    Gap(20.h),
                    if (isSessionExpired) ...[
                      LoginWarningBanner(
                        message: localization.sessionExpiredWarning,
                        isSessionExpired: true,
                      ),
                      Gap(16.h),
                    ] else if (state is LoginErrorState) ...[
                      LoginWarningBanner(
                        message: localization.signInWithCorporateCredentials,
                        isSessionExpired: false,
                      ),
                    ],

                    LoginForm(),
                    Row(
                      children: [
                        Expanded(child: Divider(color: AppColors.secondary)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Text(
                            localization.or,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                    Gap(24.h),
                    QuickSignInButton(
                      onTap: () {
                        context.go(AppRoutes.fingerprintScreen);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
