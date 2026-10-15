import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workwise/features/setting/domain/usecases/get_biometric_setting_usecase.dart';
import 'package:workwise/features/setting/domain/usecases/toggle_biometric_setting_usecase.dart';
import 'package:workwise/features/setting/presentation/cubit/setting_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required this.getBiometricSettingUseCase,
    required this.toggleBiometricSettingUseCase,
  }) : super(const SettingsState()) {
    _loadSettings();
  }

  final GetBiometricSettingUseCase getBiometricSettingUseCase;
  final ToggleBiometricSettingUseCase toggleBiometricSettingUseCase;

  bool get isBiometricEnabled => state.isBiometricEnabled;

  Future<void> _loadSettings() async {
    emit(state.copyWith(status: SettingStatus.loading));

    try {
      final enabled = await getBiometricSettingUseCase();

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

    final result = await toggleBiometricSettingUseCase();

    if (isClosed) return;

    result.fold(
      (failure) {
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
        emit(
          state.copyWith(
            status: SettingStatus.success,
            isBiometricEnabled: response.isEnabled,
            isBiometricLoading: false,
            clearErrorMessage: true,
          ),
        );
      },
    );
  }
}