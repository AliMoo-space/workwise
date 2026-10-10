
import 'package:workwise/core/utils/json_helper.dart';

class ForgotPasswordResponseModel {
  const ForgotPasswordResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final ForgotPasswordDataModel data;

  factory ForgotPasswordResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ForgotPasswordResponseModel(
      success: JsonHelper.required<bool>(json, 'success'),
      message: JsonHelper.required<String>(json, 'message'),
      data: ForgotPasswordDataModel.fromJson(
        JsonHelper.required<Map<String, dynamic>>(json, 'data'),
      ),
    );
  }
}

class ForgotPasswordDataModel {
  const ForgotPasswordDataModel({
    required this.email,
    required this.resetToken,
  });

  final String email;
  final String resetToken;

  factory ForgotPasswordDataModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ForgotPasswordDataModel(
      email: JsonHelper.required<String>(json, 'email'),
      resetToken: JsonHelper.required<String>(json, 'reset_token'),
    );
  }
}