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
      success: json['success'] as bool,
      message: json['message'] as String,
      data: LoginDataModel.fromJson(
        json['data'] as Map<String, dynamic>,
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
      accessToken: json['access_token'] as String,
      tokenType: json['token_type'] as String,
      expiresIn: json['expires_in'] as String,
      user: LoginUserModel.fromJson(
        json['user'] as Map<String, dynamic>,
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
  final String employeeCode;
  final String jobTitle;
  final String employmentType;
  final String startDate;
  final String status;
  final String? address;
  final String? avatarUrl;
  final String role;
  final String roleLabel;
  final String locale;
  final List<String> permissions;
  final String createdAt;

  factory LoginUserModel.fromJson(Map<String, dynamic> json) {
    return LoginUserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      employeeCode: json['employee_code'] as String,
      jobTitle: json['job_title'] as String,
      employmentType: json['employment_type'] as String,
      startDate: json['start_date'] as String,
      status: json['status'] as String,
      address: json['address'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      role: json['role'] as String,
      roleLabel: json['role_label'] as String,
      locale: json['locale'] as String,
      permissions: List<String>.from(
        json['permissions'] as List,
      ),
      createdAt: json['created_at'] as String,
    );
  }
}