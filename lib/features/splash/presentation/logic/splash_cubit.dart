// ignore_for_file: dead_code

import 'package:flutter_bloc/flutter_bloc.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  // الحاله الاولي في ال state
  SplashCubit() : super(SplashInitial());

  // هنفحص دي اول مره يسجل ولا لا
  void checkAuthSession() async {
    // الحاله التانيه في الstate
    emit(SplashLoading());

    // ثانيتين تحميل
    await Future.delayed(const Duration(seconds: 5));

    // هل اليوزر مسجل
    bool isLoggedIn = false;
    bool isFirstTime = false;
    // الاتنين فولس لحد ما ناخد الداتا من الباك
    //عشان دايما يبعتني للوج ان
    if (isFirstTime) {
      emit(FirstTimeState());// تالت حاله في ال state 
    } else if (isLoggedIn) {
      emit(AuthenticatedState()); // رابع حاله في ال state
    } else {
      emit(UnauthenticatedState()); // خامس حاله في ال state
    }
  }
}
