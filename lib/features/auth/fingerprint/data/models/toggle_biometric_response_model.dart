
import 'package:workwise/core/utils/json_helper.dart';

class ToggleBiometricResponseModel {
  const ToggleBiometricResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final ToggleBiometricDataModel data;

  factory ToggleBiometricResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ToggleBiometricResponseModel(
      success: JsonHelper.required<bool>(json, 'success'),
      message: JsonHelper.required<String>(json, 'message'),
      data: ToggleBiometricDataModel.fromJson(
        JsonHelper.required<Map<String, dynamic>>(json, 'data'),
      ),
    );
  }
}

class ToggleBiometricDataModel {
  const ToggleBiometricDataModel({
    required this.isEnabled,
    required this.biometricToken,
  });

  final bool isEnabled;
  final String? biometricToken;

  factory ToggleBiometricDataModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ToggleBiometricDataModel(
      isEnabled: JsonHelper.required<bool>(json, 'is_enabled'),
      biometricToken: JsonHelper.optional<String>(
        json,
        'biometric_token',
      ),
    );
  }
}