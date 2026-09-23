import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit() : super(ResetPasswordInitialState());

  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<void> resetPassword() async {
    final newPassword = newPasswordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      emit(ResetPasswordErrorState('Please fill in all fields.'));
      return;
    }

    if (newPassword != confirmPassword) {
      emit(ResetPasswordErrorState('Passwords do not match.'));
      return;
    }

    emit(ResetPasswordLoadingState());

    // Simulation for API Call
    await Future.delayed(const Duration(seconds: 2));

    emit(ResetPasswordSuccessState());
  }

  @override
  Future<void> close() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }
}