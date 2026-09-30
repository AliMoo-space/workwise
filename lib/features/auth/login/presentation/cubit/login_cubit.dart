import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workwise/core/storage/local_storage.dart';
import 'package:workwise/features/auth/login/data/Repository/auth_repository.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required this.authRepository, required this.localStorage})
    : super(LoginInitialState());
  final AuthRepository authRepository;
  final LocalStorage localStorage;
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordHidden = true;
  bool keepMeSignedIn = false;
  void togglePasswordVisibility() {
    isPasswordHidden = !isPasswordHidden;
    emit(LoginPasswordVisibilityState());
  }

  void toggleKeepMeSignedIn(bool? value) {
    keepMeSignedIn = value ?? false;
    emit(LoginKeepMeSignedInState());
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    emit(LoginLoadingState());
    final result = await authRepository.login(
      email: emailController.text.trim(),
      password: passwordController.text,
    );
    result.fold(
      (failure) {
        emit(LoginErrorState(failure.message));
      },
      (_) async {
        await localStorage.saveKeepMeSignedIn(keepMeSignedIn);
        emit(LoginSuccessState());
      },
    );
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
