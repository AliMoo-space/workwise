import 'package:workwise/core/utils/json_helper.dart';

class LoginResponseModel {
  const LoginResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final LoginDataModel data;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      success: JsonHelper.required<bool>(json, 'success'),
      message: JsonHelper.required<String>(json, 'message'),
      data: LoginDataModel.fromJson(
        JsonHelper.required<Map<String, dynamic>>(json, 'data'),
      ),
    );
  }
}

class LoginDataModel {
  const LoginDataModel({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.user,
  });

  final String accessToken;
  final String tokenType;
  final String expiresIn;
  final LoginUserModel user;

  factory LoginDataModel.fromJson(Map<String, dynamic> json) {
    return LoginDataModel(
      accessToken: JsonHelper.required<String>(json, 'access_token'),
      tokenType: JsonHelper.required<String>(json, 'token_type'),
      expiresIn: JsonHelper.required<String>(json, 'expires_in'),
      user: LoginUserModel.fromJson(
        JsonHelper.required<Map<String, dynamic>>(json, 'user'),
      ),
    );
  }
}

class LoginUserModel {
  const LoginUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.employeeCode,
    required this.jobTitle,
    required this.employmentType,
    required this.startDate,
    required this.status,
    required this.address,
    required this.avatarUrl,
    required this.role,
    required this.roleLabel,
    required this.locale,
    required this.permissions,
    required this.createdAt,
  });

  final int id;
  final String name;
  final String email;

  final String? phone;

  final String? employeeCode;
  final String? jobTitle;
  final String? employmentType;
  final String? startDate;

  final String status;

  final String? address;
  final String? avatarUrl;

  final String role;
  final String roleLabel;
  final String locale;

  final List<String> permissions;

  final String createdAt;

  factory LoginUserModel.fromJson(Map<String, dynamic> json) {
    final permissionsJson = JsonHelper.required<List<dynamic>>(
      json,
      'permissions',
    );

    return LoginUserModel(
      id: JsonHelper.required<int>(json, 'id'),
      name: JsonHelper.required<String>(json, 'name'),
      email: JsonHelper.required<String>(json, 'email'),

      phone: JsonHelper.optional<String>(json, 'phone'),

      employeeCode: JsonHelper.optional<String>(json, 'employee_code'),
      jobTitle: JsonHelper.optional<String>(json, 'job_title'),
      employmentType: JsonHelper.optional<String>(json, 'employment_type'),
      startDate: JsonHelper.optional<String>(json, 'start_date'),

      status: JsonHelper.required<String>(json, 'status'),

      address: JsonHelper.optional<String>(json, 'address'),
      avatarUrl: JsonHelper.optional<String>(json, 'avatar_url'),

      role: JsonHelper.required<String>(json, 'role'),
      roleLabel: JsonHelper.required<String>(json, 'role_label'),
      locale: JsonHelper.required<String>(json, 'locale'),

      permissions: permissionsJson
          .map((permission) => permission as String)
          .toList(),

      createdAt: JsonHelper.required<String>(json, 'created_at'),
    );
  }
}
