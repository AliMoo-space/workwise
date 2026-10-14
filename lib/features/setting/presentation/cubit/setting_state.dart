import 'package:equatable/equatable.dart';

enum SettingStatus { initial, loading, success, failure }

class SettingsState extends Equatable {
  final SettingStatus status;
  final bool isBiometricEnabled;
  final bool isBiometricLoading;
  final String selectedLanguage;
  final String? errorMessage;

  const SettingsState({
    this.status = SettingStatus.initial,
    this.isBiometricEnabled = false,
    this.isBiometricLoading = false,
    this.selectedLanguage = 'English',
    this.errorMessage,
  });

  SettingsState copyWith({
    SettingStatus? status,
    bool? isBiometricEnabled,
    bool? isBiometricLoading,
    String? selectedLanguage,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return SettingsState(
      status: status ?? this.status,
      isBiometricEnabled:
          isBiometricEnabled ?? this.isBiometricEnabled,
      isBiometricLoading:
          isBiometricLoading ?? this.isBiometricLoading,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        isBiometricEnabled,
        isBiometricLoading,
        selectedLanguage,
        errorMessage,
      ];
}