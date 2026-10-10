
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:workwise/features/auth/fingerprint/data/Repository/fingerprint_repository.dart';
import 'finger_print_state.dart';

class FingerprintCubit extends Cubit<FingerprintState> {
  FingerprintCubit({
    required this.fingerprintRepository,
  }) : super(FingerprintInitialState());

  final FingerprintRepository fingerprintRepository;
  final LocalAuthentication auth = LocalAuthentication();

  Future<void> authenticateWithBiometrics() async {
    if (state is FingerprintLoadingState) return;

    emit(FingerprintLoadingState());

    try {
      // لازم يكون المستخدم فعّل البصمة قبل كده.
      final hasBiometricToken =
          await fingerprintRepository.hasBiometricToken();

      if (!hasBiometricToken) {
        emit(
          FingerprintErrorState(
            'Biometric login is disabled. Please sign in with your email and password.',
          ),
        );
        return;
      }

      final canAuthenticate = await auth.isDeviceSupported();

      if (!canAuthenticate) {
        emit(
          FingerprintErrorState(
            'Biometric or device authentication is not available on this device.',
          ),
        );
        return;
      }

      final didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to sign in to WorkWise',
        persistAcrossBackgrounding: true,
      );

      if (!didAuthenticate) {
        emit(
          FingerprintErrorState('Authentication canceled or failed.'),
        );
        return;
      }

      // بعد نجاح مصادقة الجهاز، نطلب Access Token من السيرفر.
      final result = await fingerprintRepository.biometricLogin();

      result.fold(
        (failure) => emit(FingerprintErrorState(failure.message)),
        (_) => emit(FingerprintSuccessState()),
      );
    } on PlatformException catch (e) {
      emit(
        FingerprintErrorState(
          e.message ?? 'An error occurred during authentication.',
        ),
      );
    } catch (_) {
      emit(
        FingerprintErrorState('An unexpected error occurred.'),
      );
    }
  }
}