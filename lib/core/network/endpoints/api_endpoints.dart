abstract final class ApiEndpoints {
  // Auth
  static const String login = '/api/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh-token';
  static const String logout = '/auth/logout';

  // Forgot Password
  static const String forgetPassword = '/api/auth/forget-password';
  static const String verifyOtp = '/api/auth/forgot-password/verify-otp';
  static const String resendOtp = '/api/auth/forgot-password/resend-otp';
  static const String resetPassword = '/api/auth/forgot-password/reset';

  // User
  static const String profile = '/users/profile';
  static const String users = '/users';

  // Add project-specific endpoints below.
}
