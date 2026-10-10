import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workwise/core/storage/local_storage.dart';
import 'package:workwise/features/auth/login/data/Repository/login_repository.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required this.authRepository, required this.localStorage})
    : super(LoginInitialState());

  final AuthRepository authRepository;
  LoginCubit({
    required this.loginRepository,
    required this.localStorage,
  }) : super(LoginInitialState());

  final LoginRepository loginRepository;
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

    final result = await loginRepository.login(
      email: emailController.text.trim(),
      password: passwordController.text,
    );


    result.fold(
      (failure) {
        emit(LoginErrorState(failure.message));
      },
      (loginResponse) async {
        await localStorage.saveKeepMeSignedIn(keepMeSignedIn);

        // Added userId storage for Career Coach feature.
        final userId = loginResponse.data.user.id;
        await localStorage.saveUserId(userId);

        // Debug: Check userId returned from Login API.
        debugPrint('========== LOGIN DEBUG ==========');
        debugPrint('User ID from API: $userId');

        // Added employeeCode storage for Career Coach feature.
        final employeeCode = loginResponse.data.user.employeeCode;

        // Debug: Check employeeCode returned from Login API.
        debugPrint('Employee Code from API: $employeeCode');

        // Save employeeCode locally when it exists.
        if (employeeCode != null && employeeCode.isNotEmpty) {
          await localStorage.saveEmployeeCode(employeeCode);

          // Debug: Check employeeCode saved in LocalStorage.
          final savedEmployeeCode = localStorage.getEmployeeCode();

          debugPrint('Employee Code saved in LocalStorage: $savedEmployeeCode');
        } else {
          // Debug: employeeCode was null or empty.
          debugPrint('WARNING: Employee Code is NULL or EMPTY');
        }

        // Debug: Check final values stored in LocalStorage.
        debugPrint('User ID from LocalStorage: ${localStorage.getUserId()}');
        debugPrint(
          'Employee Code from LocalStorage: '
          '${localStorage.getEmployeeCode()}',
        );
        debugPrint('=================================');

      (_) async {
        await localStorage.saveKeepMeSignedIn(
          keepMeSignedIn,
        );

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