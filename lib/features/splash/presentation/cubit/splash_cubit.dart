import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workwise/core/storage/local_storage.dart';
import 'package:workwise/core/storage/secure_storage.dart';

import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit({
    required this.secureStorage,
    required this.localStorage,
  }) : super(SplashInitial());

  final SecureStorage secureStorage;
  final LocalStorage localStorage;

  Future<void> checkAuthSession() async {
    emit(SplashLoading());

    final accessToken = await secureStorage.getAccessToken();
    final keepMeSignedIn = localStorage.getKeepMeSignedIn();

    if (accessToken != null &&
        accessToken.isNotEmpty &&
        keepMeSignedIn) {
      emit(AuthenticatedState());
    } else {
      emit(UnauthenticatedState());
    }
  }
}