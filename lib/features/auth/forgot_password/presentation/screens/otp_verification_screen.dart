// ignore_for_file: unnecessary_cast

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:workwise/core/design_system/widgets/buttons/app_button.dart';
import 'package:workwise/core/routing/app_routes.dart';
import 'package:workwise/features/auth/forgot_password/logic/forgot_password_cubit.dart';
import 'package:workwise/features/auth/forgot_password/logic/forgot_password_state.dart';

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
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: theme.colorScheme.outline),
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
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<ForgotPasswordCubit>();
          final isError = state is VerifyOtpErrorState;

          return Scaffold(
            backgroundColor: theme.colorScheme.onSurface,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded,
                    color: theme.colorScheme.onPrimary),
                onPressed: () => context.pop(),
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Gap(20.h),
                    Icon(
                      Icons.mark_email_read_outlined,
                      size: 70.sp,
                      color: theme.colorScheme.primary,
                    ),
                    Gap(20.h),
                    Text(
                      'Verify Your Email',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    Gap(10.h),
                    Text(
                      'Please enter the 6-digit code sent to\n${widget.email}',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimary.withOpacity(0.7),
                      ),
                    ),
                    Gap(32.h),

                    // Pinput Widget (6 Digits)
                    Pinput(
                      length: 6,
                      controller: cubit.otpController,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      errorPinTheme: errorPinTheme,
                      forceErrorState: isError,
                    ),

                    if (isError) ...[
                      Gap(12.h),
                      Text(
                        (state as VerifyOtpErrorState).message,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.error,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],

                    Gap(32.h),

                    // Resend Code Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn't receive code? ",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                        GestureDetector(
                          onTap: _canResend ? () => cubit.resendOtp() : null,
                          child: Text(
                            _canResend
                                ? 'Resend Code'
                                : 'Resend in 00:${_startSeconds.toString().padLeft(2, '0')}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: _canResend
                                  ? theme.colorScheme.secondary
                                  : theme.colorScheme.onPrimary.withOpacity(0.5),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    Gap(40.h),

                    // Submit Button
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