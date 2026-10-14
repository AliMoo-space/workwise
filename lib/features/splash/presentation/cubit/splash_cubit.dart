import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workwise/features/splash/domain/usecases/check_auth_session_usecase.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit({
    required this.checkAuthSessionUseCase,
  }) : super(SplashInitial());

  final CheckAuthSessionUseCase checkAuthSessionUseCase;

  Future<void> checkAuthSession() async {
    emit(SplashLoading());

    final isAuthenticated = await checkAuthSessionUseCase();

    if (isAuthenticated) {
      emit(AuthenticatedState());
    } else {
      emit(UnauthenticatedState());
    }
  }
}