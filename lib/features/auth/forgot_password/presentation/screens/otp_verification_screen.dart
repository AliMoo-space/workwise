import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:workwise/core/design_system/spacing/app_radius.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/buttons/app_button.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/routing/app_routes.dart';
import 'package:workwise/features/auth/forgot_password/presentation/logic/forgot_password_cubit.dart';
import 'package:workwise/features/auth/forgot_password/presentation/logic/forgot_password_state.dart';

import 'package:workwise/features/auth/forgot_password/presentation/widgets/otp_header_widget.dart';
import 'package:workwise/features/auth/forgot_password/presentation/widgets/otp_resend_section.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;

  const OtpVerificationScreen({super.key, required this.email});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  Timer? _timer;
  int _startSeconds = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() {
      _startSeconds = 60;
      _canResend = false;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_startSeconds == 0) {
        setState(() {
          _timer?.cancel();
          _canResend = true;
        });
      } else {
        setState(() {
          _startSeconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final defaultPinTheme = PinTheme(
      width: 48.w,
      height: 56.h,
      textStyle: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.onSurface,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.radius12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        border: Border.all(color: theme.colorScheme.primary, width: 2.w),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        border: Border.all(color: theme.colorScheme.error, width: 2.w),
      ),
    );

    return BlocProvider(
      create: (context) => ForgotPasswordCubit(),
      child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          if (state is VerifyOtpSuccessState) {
            context.push(
              AppRoutes.createNewPasswordScreen,
              extra: widget.email,
            );
          } else if (state is ResendOtpSuccessState) {
            _startTimer();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Verification code resent to ${widget.email}'),
                backgroundColor: theme.colorScheme.tertiary,
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<ForgotPasswordCubit>();
          final isError = state is VerifyOtpErrorState;

          return Scaffold(
            backgroundColor: theme.colorScheme.surface,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: theme.colorScheme.onSurface,
                ),
                onPressed: () => context.pop(),
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.space20,
                  vertical: AppSpacing.space16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    OtpHeaderWidget(email: widget.email),
                    const Gap(AppSpacing.space32),

                    Pinput(
                      length: 6,
                      controller: cubit.otpController,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      errorPinTheme: errorPinTheme,
                      forceErrorState: isError,
                    ),

                    if (isError) ...[
                      const Gap(AppSpacing.space12),
                      AppText(
                        (state).message,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.error,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],

                    const Gap(AppSpacing.space32),

                    OtpResendSection(
                      canResend: _canResend,
                      startSeconds: _startSeconds,
                      onResend: () => cubit.resendOtp(),
                    ),

                    const Gap(AppSpacing.space40),

                    AppButton(
                      text: 'Verify Code',
                      height: 52.h,
                      isLoading: state is VerifyOtpLoadingState,
                      onPressed: () => cubit.verifyOtp(),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
