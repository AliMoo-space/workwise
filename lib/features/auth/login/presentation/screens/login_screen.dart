import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:workwise/core/design_system/widgets/layout/app_divider.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';
import 'package:workwise/core/routing/app_routes.dart';
import 'package:workwise/features/auth/login/presentation/logic/login_cubit.dart';
import 'package:workwise/features/auth/login/presentation/logic/login_state.dart';
import 'package:workwise/features/auth/login/presentation/widgets/login_form.dart';
import 'package:workwise/features/auth/login/presentation/widgets/login_header_widget.dart';
import 'package:workwise/features/auth/login/presentation/widgets/login_warning_banner.dart';
import 'package:workwise/features/auth/login/presentation/widgets/quick_sign_in_button.dart';

class LoginScreen extends StatelessWidget {
  final bool isSessionExpired;

  const LoginScreen({super.key, this.isSessionExpired = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        body: SafeArea(
          child: BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is LoginSuccessState) {
                context.go(AppRoutes.mainScreen);
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Gap(AppSpacing.space12),
                    const LoginHeaderWidget(),
                    const Gap(AppSpacing.space20),
                    if (isSessionExpired) ...[
                      LoginWarningBanner(
                        message: context.l10n.sessionExpiredWarning,
                        isSessionExpired: true,
                      ),
                      const Gap(AppSpacing.space16),
                    ] else if (state is LoginErrorState) ...[
                      LoginWarningBanner(
                        message: context.l10n.signInWithCorporateCredentials,
                        isSessionExpired: false,
                      ),
                    ],

                    const LoginForm(),
                    Row(
                      children: [
                        Expanded(
                          child: AppDivider(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: AppText(
                            context.l10n.or,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        Expanded(
                          child: AppDivider(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                    const Gap(AppSpacing.space24),
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