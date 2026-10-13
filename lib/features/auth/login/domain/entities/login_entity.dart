class UserEntity {
  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.employeeCode,
    required this.role,
  });

  final int id;
  final String name;
  final String email;
  final String? employeeCode;
  final String role;
}

class LoginDataEntity {
  const LoginDataEntity({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.user,
  });

  final String accessToken;
  final String tokenType;
  final String expiresIn;
  final UserEntity user;
}