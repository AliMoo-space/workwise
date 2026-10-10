import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workwise/features/auth/reset_password/data/Repository/reset_password_repository.dart';
import 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit({
    required this.resetPasswordRepository,
    required this.resetToken,
  }) : super(ResetPasswordInitialState());

  final ResetPasswordRepository resetPasswordRepository;
  final String resetToken;

  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<void> resetPassword() async {
    final newPassword = newPasswordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      emit(
        ResetPasswordErrorState(
          'Please fill in all fields.',
        ),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      emit(
        ResetPasswordErrorState(
          'Passwords do not match.',
        ),
      );
      return;
    }

    emit(ResetPasswordLoadingState());

    final result = await resetPasswordRepository.resetPassword(
      resetToken: resetToken,
      password: newPassword,
      passwordConfirmation: confirmPassword,
    );

    result.fold(
      (failure) {
        emit(
          ResetPasswordErrorState(
            failure.message,
          ),
        );
      },
      (message) {
        emit(
          ResetPasswordSuccessState(
            message,
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }
}