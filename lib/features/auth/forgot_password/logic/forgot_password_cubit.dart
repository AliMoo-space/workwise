import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit() : super(ForgotPasswordInitialState());

  // Controllers
  final emailController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final otpController = TextEditingController();

  // 1. Send OTP to Email
  Future<void> sendOtp() async {
    emit(SendOtpLoadingState());
    
    await Future.delayed(const Duration(seconds: 2));
    
    emit(SendOtpSuccessState(emailController.text.trim()));
  }

  // 2. Verify OTP Code
  Future<void> verifyOtp() async {
    final otp = otpController.text.trim();
    if (otp.length < 6) {
      emit(VerifyOtpErrorState('Please enter the complete 6-digit code.'));
      return;
    }

    emit(VerifyOtpLoadingState());
    await Future.delayed(const Duration(seconds: 2));

    // Mock verification check (e.g., correct code is 123456)
    if (otp == "123456") {
      emit(VerifyOtpSuccessState());
    } else {
      emit(VerifyOtpErrorState('Invalid verification code. Please try again.'));
    }
  }

  // 3. Resend OTP
  Future<void> resendOtp() async {
    emit(ResendOtpLoadingState());
    await Future.delayed(const Duration(seconds: 2));
    emit(ResendOtpSuccessState());
  }

  // 4. Reset Password
  Future<void> resetPassword() async {
    if (newPasswordController.text != confirmPasswordController.text) {
      emit(ResetPasswordErrorState('Passwords do not match.'));
      return;
    }

    emit(ResetPasswordLoadingState());
    await Future.delayed(const Duration(seconds: 2));
    emit(ResetPasswordSuccessState());
  }

  @override
  Future<void> close() {
    emailController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    otpController.dispose();
    return super.close();
  }
}