import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:workwise/core/routing/app_routes.dart';
import 'package:workwise/features/auth/fingerprint/presentation/logic/finger_print_cubit.dart';
import 'package:workwise/features/auth/fingerprint/presentation/logic/finger_print_state.dart';
import 'package:workwise/features/auth/fingerprint/presentation/widgets/finger_print_header_widget.dart';
import 'package:workwise/features/auth/fingerprint/presentation/widgets/finger_print_widget.dart';
import 'package:workwise/features/auth/login/presentation/widgets/login_warning_banner.dart';
import 'package:workwise/generated/app_localizations.dart';

class FingerPrintScreen extends StatelessWidget {
  final bool isSessionExpired;

  const FingerPrintScreen({super.key, this.isSessionExpired = false});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    return BlocProvider(
      create: (context) => FingerprintCubit()..authenticateWithBiometrics(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onSurface,
        body: SafeArea(
          child: BlocConsumer<FingerprintCubit, FingerprintState>(
            listener: (context, state) {
              if (state is FingerprintSuccessState) {
                context.go(AppRoutes.homeScreen);
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Gap(12.h),
                    const FingerprintHeaderWidget(),
                    Gap(20.h),
                    
                    if (isSessionExpired) ...[
                       Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: LoginWarningBanner(
                          message: localization.sessionExpiredWarning,
                          isSessionExpired: true,
                        ),
                      ),
                      Gap(16.h),
                    ] else if (state is FingerprintErrorState) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: LoginWarningBanner(
                          message: state.message,
                          isSessionExpired: false,
                        ),
                      ),
                      Gap(16.h),
                    ],

                    // مكون البصمة والزر السفلي
                    const FingerPrintWidget(),
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