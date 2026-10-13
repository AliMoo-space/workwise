import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workwise/core/storage/local_storage.dart';
import 'package:workwise/features/auth/login/domain/usecases/login_usecase.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required this.loginUseCase,
    required this.localStorage,
  }) : super(LoginInitialState());

  final LoginUseCase loginUseCase;
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

    // استدعاء الـ UseCase بدل الـ Repository مباشرة
    final result = await loginUseCase(
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    result.fold(
      (failure) {
        emit(LoginErrorState(failure.message));
      },
      (loginDataEntity) async {
        await localStorage.saveKeepMeSignedIn(keepMeSignedIn);

        // استخدام الـ Entity اللي راجعة من طبقة الـ Domain
        final userId = loginDataEntity.user.id;
        await localStorage.saveUserId(userId);

        debugPrint('========== LOGIN DEBUG ==========');
        debugPrint('User ID from API: $userId');

        final employeeCode = loginDataEntity.user.employeeCode;
        debugPrint('Employee Code from API: $employeeCode');

        if (employeeCode != null && employeeCode.isNotEmpty) {
          await localStorage.saveEmployeeCode(employeeCode);
          final savedEmployeeCode = localStorage.getEmployeeCode();
          debugPrint('Employee Code saved in LocalStorage: $savedEmployeeCode');
        } else {
          debugPrint('WARNING: Employee Code is NULL or EMPTY');
        }

        debugPrint('User ID from LocalStorage: ${localStorage.getUserId()}');
        debugPrint(
          'Employee Code from LocalStorage: '
          '${localStorage.getEmployeeCode()}',
        );
        debugPrint('=================================');

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