import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workwise/features/setting/presentation/logic/setting_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState()) {
    _loadSettings();
  }

  bool get isBiometricEnabled => state.isBiometricEnabled;
  bool get isNotificationsEnabled => state.isNotificationsEnabled;

  void _loadSettings() {
    emit(
      state.copyWith(
        status: SettingStatus.success,
        isBiometricEnabled: false,
        isNotificationsEnabled: true,
      ),
    );
  }

  void toggleBiometric(bool value) {
    emit(state.copyWith(isBiometricEnabled: value));
    // TODO: حفظ القيمة في SharedPreferences / SecureStorage
  }

  void toggleNotifications(bool value) {
    emit(state.copyWith(isNotificationsEnabled: value));
    // TODO: حفظ القيمة في SharedPreferences
  }
}