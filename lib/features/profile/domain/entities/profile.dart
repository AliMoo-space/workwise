class Profile {
  const Profile({
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
    required this.departmentName,
    required this.companyLocationName,
    required this.managerName,
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
  final String? departmentName;
  final String? companyLocationName;
  final String? managerName;
}
