import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'finger_print_state.dart';

class FingerprintCubit extends Cubit<FingerprintState> {
  FingerprintCubit() : super(FingerprintInitialState());

  final LocalAuthentication auth = LocalAuthentication();

  Future<void> authenticateWithBiometrics() async {
    emit(FingerprintLoadingState());

    try {
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await auth.isDeviceSupported();

      if (!canAuthenticate) {
        emit(
          FingerprintErrorState(
            'Biometric authentication is not available on this device.',
          ),
        );
        return;
      }

      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to sign in to WorkWise',
        // options: const AuthenticationOptions(
        //   biometricOnly: true,
        //   stickyAuth: true,
        // ),
      );

      if (didAuthenticate) {
        // TODO (Future API Integration):
        
        emit(FingerprintSuccessState());
      } else {
        emit(FingerprintErrorState('Authentication canceled or failed.'));
      }
    } on PlatformException catch (e) {
      emit(
        FingerprintErrorState(
          e.message ?? 'An error occurred during authentication.',
        ),
      );
    }
  }
}