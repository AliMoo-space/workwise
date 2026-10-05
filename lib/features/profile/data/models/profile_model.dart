import 'package:workwise/core/constants/app_constants.dart';

class ProfileModel {
  const ProfileModel({
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
    required this.department,
    required this.companyLocation,
    required this.manager,
    required this.permissions,
    required this.createdAt,
  });

  final int id;
  final String name;
  final String email;
  final String phone;
  final String employeeCode;
  final String jobTitle;
  final String employmentType;
  final String startDate;
  final String status;
  final String address;
  final String avatarUrl;
  final String role;
  final String roleLabel;
  final String locale;
  final DepartmentModel? department;
  final CompanyLocationModel? companyLocation;
  final ManagerModel? manager;
  final List<String> permissions;
  final String createdAt;

  static String _parseAvatarUrl(Map<String, dynamic> json) {
    final dynamic rawUrl = json['avatar_url'] ??
        json['avatar'] ??
        json['image'] ??
        json['photo'] ??
        json['profile_photo'] ??
        json['profile_image'];

    if (rawUrl == null || rawUrl.toString().trim().isEmpty) {
      return '';
    }

    final url = rawUrl.toString().trim();
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }

    final base = AppConstants.baseUrl.endsWith('/')
        ? AppConstants.baseUrl.substring(0, AppConstants.baseUrl.length - 1)
        : AppConstants.baseUrl;
    final path = url.startsWith('/') ? url : '/$url';
    return '$base$path';
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      employeeCode: json['employee_code'] ?? '',
      jobTitle: json['job_title'] ?? '',
      employmentType: json['employment_type'] ?? '',
      startDate: json['start_date'] ?? '',
      status: json['status'] ?? '',
      address: json['address'] ?? '',
      avatarUrl: _parseAvatarUrl(json),
      role: json['role'] ?? '',
      roleLabel: json['role_label'] ?? '',
      locale: json['locale'] ?? '',
      department: json['department'] != null
          ? DepartmentModel.fromJson(json['department'])
          : null,
      companyLocation: json['company_location'] != null
          ? CompanyLocationModel.fromJson(json['company_location'])
          : null,
      manager: json['manager'] != null
          ? ManagerModel.fromJson(json['manager'])
          : null,
      permissions: List<String>.from(json['permissions'] ?? const []),
      createdAt: json['created_at'] ?? '',
    );
  }
}

class DepartmentModel {
  const DepartmentModel({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class CompanyLocationModel {
  const CompanyLocationModel({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory CompanyLocationModel.fromJson(Map<String, dynamic> json) {
    return CompanyLocationModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class ManagerModel {
  const ManagerModel({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory ManagerModel.fromJson(Map<String, dynamic> json) {
    return ManagerModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}