import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workwise/features/setting/presentation/logic/setting_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsInitialState());

  bool isBiometricEnabled = true;
  bool isNotificationsEnabled = true;
  String selectedLanguage = 'English';

  void toggleBiometric(bool value) {
    isBiometricEnabled = value;
    _emitUpdatedState();
  }

  void toggleNotifications(bool value) {
    isNotificationsEnabled = value;
    _emitUpdatedState();
  }

  void changeLanguage(String newLanguage) {
    selectedLanguage = newLanguage;
    _emitUpdatedState();
  }

  void _emitUpdatedState() {
    emit(
      SettingsChangedState(
        isBiometricEnabled: isBiometricEnabled,
        isNotificationsEnabled: isNotificationsEnabled,
        selectedLanguage: selectedLanguage,
      ),
    );
  }
}