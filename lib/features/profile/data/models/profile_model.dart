import '../../domain/entities/profile.dart';

class ProfileModel {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? employeeCode;
  final String? jobTitle;
  final String? employmentType;
  final String? startDate;
  final String? status;
  final String? address;
  final String? avatarUrl;
  final String? role;
  final String? roleLabel;
  final String? locale;

  const ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.employeeCode,
    this.jobTitle,
    this.employmentType,
    this.startDate,
    this.status,
    this.address,
    this.avatarUrl,
    this.role,
    this.roleLabel,
    this.locale,
  });

  factory ProfileModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProfileModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      employeeCode: json['employee_code'] as String?,
      jobTitle: json['job_title'] as String?,
      employmentType: json['employment_type'] as String?,
      startDate: json['start_date'] as String?,
      status: json['status'] as String?,
      address: json['address'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      role: json['role'] as String?,
      roleLabel: json['role_label'] as String?,
      locale: json['locale'] as String?,
    );
  }

  Profile toEntity() {
    return Profile(
      id: id,
      name: name,
      email: email,
      phone: phone,
      employeeCode: employeeCode,
      jobTitle: jobTitle,
      employmentType: employmentType,
      startDate: startDate,
      status: status,
      address: address,
      avatarUrl: avatarUrl,
      role: role,
      roleLabel: roleLabel,
      locale: locale,
    );
  }
}