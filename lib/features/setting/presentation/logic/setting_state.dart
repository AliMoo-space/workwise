import 'package:equatable/equatable.dart';

enum SettingStatus { initial, loading, success, failure }

class SettingsState extends Equatable {
  final SettingStatus status;
  final bool isBiometricEnabled;
  final bool isNotificationsEnabled;
  final String selectedLanguage;
  final String? errorMessage;

  const SettingsState({
    this.status = SettingStatus.initial,
    this.isBiometricEnabled = false,
    this.isNotificationsEnabled = true,
    this.selectedLanguage = 'English',
    this.errorMessage,
  });

  SettingsState copyWith({
    SettingStatus? status,
    bool? isBiometricEnabled,
    bool? isNotificationsEnabled,
    String? selectedLanguage,
    String? errorMessage,
  }) {
    return SettingsState(
      status: status ?? this.status,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      isNotificationsEnabled:
          isNotificationsEnabled ?? this.isNotificationsEnabled,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        isBiometricEnabled,
        isNotificationsEnabled,
        selectedLanguage,
        errorMessage,
      ];
}