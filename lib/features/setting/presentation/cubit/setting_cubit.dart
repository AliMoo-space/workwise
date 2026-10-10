
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workwise/features/auth/fingerprint/data/Repository/fingerprint_repository.dart';
import 'package:workwise/features/setting/presentation/cubit/setting_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required this.fingerprintRepository,
  }) : super(const SettingsState()) {
    _loadSettings();
  }

  final FingerprintRepository fingerprintRepository;

  bool get isBiometricEnabled => state.isBiometricEnabled;
  bool get isNotificationsEnabled => state.isNotificationsEnabled;

  Future<void> _loadSettings() async {
    emit(state.copyWith(status: SettingStatus.loading));

    try {
      // مفيش endpoint لاسترجاع حالة البصمة ضمن الـ API
      // اللي راجعناه؛ لذلك نستخدم وجود التوكن المحلي.
      final enabled =
          await fingerprintRepository.hasBiometricToken();

      if (isClosed) return;

      emit(
        state.copyWith(
          status: SettingStatus.success,
          isBiometricEnabled: enabled,
          clearErrorMessage: true,
        ),
      );
    } catch (_) {
      if (isClosed) return;

      emit(
        state.copyWith(
          status: SettingStatus.failure,
          errorMessage: 'Unable to load biometric settings.',
        ),
      );
    }
  }

  Future<void> toggleBiometric(bool requestedValue) async {
    if (state.isBiometricLoading ||
        requestedValue == state.isBiometricEnabled) {
      return;
    }

    final previousValue = state.isBiometricEnabled;

    emit(
      state.copyWith(
        isBiometricLoading: true,
        clearErrorMessage: true,
      ),
    );

    final result = await fingerprintRepository.toggleBiometrics();

    if (isClosed) return;

    result.fold(
      (failure) {
        // الحالة القديمة تفضل كما هي عند فشل الطلب.
        emit(
          state.copyWith(
            status: SettingStatus.failure,
            isBiometricEnabled: previousValue,
            isBiometricLoading: false,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        // نعتمد على الحالة التي أكدها السيرفر.
        emit(
          state.copyWith(
            status: SettingStatus.success,
            isBiometricEnabled: response.data.isEnabled,
            isBiometricLoading: false,
            clearErrorMessage: true,
          ),
        );
      },
    );
  }

  void toggleNotifications(bool value) {
    emit(state.copyWith(isNotificationsEnabled: value));
  }
}