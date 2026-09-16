abstract class SettingsState {}

class SettingsInitialState extends SettingsState {}

class SettingsChangedState extends SettingsState {
  final bool isBiometricEnabled;
  final bool isNotificationsEnabled;
  final String selectedLanguage;

  SettingsChangedState({
    required this.isBiometricEnabled,
    required this.isNotificationsEnabled,
    required this.selectedLanguage,
  });
}