
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workwise/features/auth/forgot_password/domain/usecases/send_otp_usecase.dart';
import 'package:workwise/features/auth/forgot_password/domain/usecases/verify_otp_usecase.dart';
import 'package:workwise/features/auth/forgot_password/domain/usecases/resend_otp_usecase.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit({
    required this.sendOtpUseCase,
    required this.verifyOtpUseCase,
    required this.resendOtpUseCase,
    String? email,
  }) : super(ForgotPasswordInitialState()) {
    if (email != null) {
      emailController.text = email;
    }
  }

  final SendOtpUseCase sendOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final ResendOtpUseCase resendOtpUseCase;

  final emailController = TextEditingController();
  final otpController = TextEditingController();

  Future<void> sendOtp() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      emit(SendOtpErrorState('Please enter your email address.'));
      return;
    }

    emit(SendOtpLoadingState());

    final result = await sendOtpUseCase(email: email);

    result.fold(
      (failure) => emit(SendOtpErrorState(failure.message)),
      (_) => emit(SendOtpSuccessState(email)),
    );
  }

  Future<void> verifyOtp() async {
    final email = emailController.text.trim();
    final otp = otpController.text.trim();

    if (email.isEmpty) {
      emit(VerifyOtpErrorState('Email is required.'));
      return;
    }

    if (otp.length != 6) {
      emit(VerifyOtpErrorState('Please enter the complete 6-digit code.'));
      return;
    }

    emit(VerifyOtpLoadingState());

    final result = await verifyOtpUseCase(email: email, otp: otp);

    result.fold(
      (failure) => emit(VerifyOtpErrorState(failure.message)),
      (entity) => emit(VerifyOtpSuccessState(entity.resetToken)),
    );
  }

  Future<void> resendOtp() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      emit(ResendOtpErrorState('Email is required.'));
      return;
    }

    emit(ResendOtpLoadingState());

    final result = await resendOtpUseCase(email: email);

    result.fold(
      (failure) => emit(ResendOtpErrorState(failure.message)),
      (message) => emit(ResendOtpSuccessState(message)),
    );
  }

  @override
  Future<void> close() {
    emailController.dispose();
    otpController.dispose();
    return super.close();
  }
}
