class Profile {
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

  const Profile({
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
}