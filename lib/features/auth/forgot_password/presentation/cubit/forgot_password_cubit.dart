import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workwise/features/auth/forgot_password/data/Repository/forgot_password_repository.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit({
    required this.forgotPasswordRepository,
    String? email,
  }) : super(ForgotPasswordInitialState()) {
    if (email != null) {
      emailController.text = email;
    }
  }

  final ForgotPasswordRepository forgotPasswordRepository;

  final emailController = TextEditingController();
  final otpController = TextEditingController();

  Future<void> sendOtp() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      emit(
        SendOtpErrorState(
          'Please enter your email address.',
        ),
      );
      return;
    }

    emit(SendOtpLoadingState());

    final result = await forgotPasswordRepository.sendOtp(
      email: email,
    );

    result.fold(
      (failure) {
        emit(
          SendOtpErrorState(
            failure.message,
          ),
        );
      },
      (_) {
        emit(
          SendOtpSuccessState(
            email,
          ),
        );
      },
    );
  }

  Future<void> verifyOtp() async {
    final email = emailController.text.trim();
    final otp = otpController.text.trim();

    if (email.isEmpty) {
      emit(
        VerifyOtpErrorState(
          'Email is required.',
        ),
      );
      return;
    }

    if (otp.length != 6) {
      emit(
        VerifyOtpErrorState(
          'Please enter the complete 6-digit code.',
        ),
      );
      return;
    }

    emit(VerifyOtpLoadingState());

    final result = await forgotPasswordRepository.verifyOtp(
      email: email,
      otp: otp,
    );

    result.fold(
      (failure) {
        emit(
          VerifyOtpErrorState(
            failure.message,
          ),
        );
      },
      (response) {
        emit(
          VerifyOtpSuccessState(
            response.data.resetToken,
          ),
        );
      },
    );
  }

  Future<void> resendOtp() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      emit(
        ResendOtpErrorState(
          'Email is required.',
        ),
      );
      return;
    }

    emit(ResendOtpLoadingState());

    final result = await forgotPasswordRepository.resendOtp(
      email: email,
    );

    result.fold(
      (failure) {
        emit(
          ResendOtpErrorState(
            failure.message,
          ),
        );
      },
      (message) {
        emit(
          ResendOtpSuccessState(
            message,
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    emailController.dispose();
    otpController.dispose();

    return super.close();
  }
}