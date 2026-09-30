abstract final class ApiEndpoints {
  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh-token';
  static const String logout = '/auth/logout';

  // User
  static const String profile = '/users/profile';
  static const String users = '/users';

  // Add project-specific endpoints below.
  static const String employeeProfile = '/employees/profile';

  static String employeeDetails(int employeeId) {
    return '/employees/$employeeId';
  }
}
