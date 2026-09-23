import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit() : super(ForgotPasswordInitialState());

  final emailController = TextEditingController();
  final otpController = TextEditingController();

  TextEditingController? get newPasswordController => null;

  Future<void> sendOtp() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      emit(SendOtpErrorState('Please enter your email address.'));
      return;
    }

    emit(SendOtpLoadingState());

    // API Call Simulation
    await Future.delayed(const Duration(seconds: 2));

    emit(SendOtpSuccessState(email));
  }

  Future<void> verifyOtp() async {
    final otp = otpController.text.trim();
    if (otp.length < 6) {
      emit(VerifyOtpErrorState('Please enter the complete 6-digit code.'));
      return;
    }

    emit(VerifyOtpLoadingState());

    // API Call Simulation
    await Future.delayed(const Duration(seconds: 2));

    emit(VerifyOtpSuccessState());
  }

  Future<void> resendOtp() async {
    emit(ResendOtpLoadingState());

    // API Call Simulation
    await Future.delayed(const Duration(seconds: 2));

    emit(ResendOtpSuccessState());
  }

  @override
  Future<void> close() {
    emailController.dispose();
    otpController.dispose();
    return super.close();
  }
}