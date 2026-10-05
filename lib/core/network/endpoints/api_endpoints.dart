abstract final class ApiEndpoints {
  // Auth
  static const String login = '/api/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh-token';
  static const String logout = '/api/auth/logout';

  // Forgot Password
  static const String forgetPassword = '/api/auth/forget-password';
  static const String verifyOtp = '/api/auth/forgot-password/verify-otp';
  static const String resendOtp = '/api/auth/forgot-password/resend-otp';
  static const String resetPassword = '/api/auth/forgot-password/reset';

  // User
  static const String profile = '/api/users/profile';
  static const String users = '/api/users';

  // Add project-specific endpoints below.
  static const String employeeProfile = '/api/employees/profile';

  static String employeeDetails(int employeeId) {
    return '/api/employees/$employeeId';
  }
}
