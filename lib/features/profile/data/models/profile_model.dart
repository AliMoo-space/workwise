import 'package:workwise/core/constants/app_constants.dart';

import 'company_location_model.dart';
import 'department_model.dart';
import 'manager_model.dart';

export 'company_location_model.dart';
export 'department_model.dart';
export 'manager_model.dart';

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
    this.avatarFileId,
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
  final int? avatarFileId;
  final String role;
  final String roleLabel;
  final String locale;
  final DepartmentModel? department;
  final CompanyLocationModel? companyLocation;
  final ManagerModel? manager;
  final List<String> permissions;
  final String createdAt;

  static String _parseAvatarUrl(Map<String, dynamic> json) {
    final dynamic rawUrl =
        json['avatar_url'] ??
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

  static int? _parseAvatarFileId(String avatarUrl) {
    final pathSegments = Uri.tryParse(avatarUrl)?.pathSegments;
    if (pathSegments == null) {
      return null;
    }

    final filesIndex = pathSegments.indexOf('files');
    if (filesIndex < 0 || filesIndex + 1 >= pathSegments.length) {
      return null;
    }

    return int.tryParse(pathSegments[filesIndex + 1]);
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final avatarUrl = _parseAvatarUrl(json);

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
      avatarUrl: avatarUrl,
      avatarFileId: _parseAvatarFileId(avatarUrl),
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
