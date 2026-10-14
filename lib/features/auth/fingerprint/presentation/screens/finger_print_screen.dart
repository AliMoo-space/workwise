import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/localization/localization_extension.dart';
import 'package:workwise/core/routing/app_routes.dart';
import 'package:workwise/core/services/service_locator.dart';
import 'package:workwise/features/auth/fingerprint/presentation/cubit/finger_print_cubit.dart';
import 'package:workwise/features/auth/fingerprint/presentation/cubit/finger_print_state.dart';
import 'package:workwise/features/auth/fingerprint/presentation/widgets/finger_print_header_widget.dart';
import 'package:workwise/features/auth/fingerprint/presentation/widgets/finger_print_widget.dart';
import 'package:workwise/features/auth/login/presentation/widgets/login_warning_banner.dart';

class FingerPrintScreen extends StatelessWidget {
  final bool isSessionExpired;

  const FingerPrintScreen({super.key, this.isSessionExpired = false});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: BlocProvider(
        create: (_) => sl<FingerprintCubit>(),
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(AppRoutes.loginScreen);
                }
              },
            ),
          ),
          body: SafeArea(
            child: BlocConsumer<FingerprintCubit, FingerprintState>(
              listener: (context, state) {
                if (state is FingerprintSuccessState) {
                  context.go(AppRoutes.mainScreen);
                }
              },
              builder: (context, state) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Gap(AppSpacing.space12),
                      const FingerprintHeaderWidget(),
                      const Gap(AppSpacing.space20),

                      if (isSessionExpired) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.space20,
                          ),
                          child: LoginWarningBanner(
                            message: context.l10n.sessionExpiredWarning,
                            isSessionExpired: true,
                          ),
                        ),
                        const Gap(AppSpacing.space16),
                      ] else if (state is FingerprintErrorState) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.space20,
                          ),
                          child: LoginWarningBanner(
                            message: state.message,
                            isSessionExpired: false,
                          ),
                        ),
                        const Gap(AppSpacing.space16),
                      ],

                      const FingerPrintWidget(),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
