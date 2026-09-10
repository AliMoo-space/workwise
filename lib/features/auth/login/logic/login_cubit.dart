import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitialState());

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
    if (formKey.currentState!.validate()) {
      emit(LoginLoadingState());
      
      await Future.delayed(const Duration(seconds: 2));
      
      // بعدين ان شاء الله 
      // لو تسجيل الدخول تمام
      // emit(LoginSuccessState());
      // لو مش تمام
      // emit(LoginErrorState('Incorrect email or password. Please try again.'));
    }
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
// dispose دي لقيتها وانا بسيرش وعرفت انها بتفضي الكاش من الداتا عشان الذاكره 
// يعني ممكن منستخدمهاش عادي 