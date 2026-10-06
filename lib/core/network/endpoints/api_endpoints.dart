abstract final class ApiEndpoints {
  // Attendance
  static const String todayAttendance = '/api/attendance/today';
  static const String checkIn = '/api/attendance/check-in';
  static const String checkOut = '/api/attendance/check-out';
  static const String attendanceHistory = '/api/attendance/history';

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

  // Performance

  static const String performance = '/api/employee/performance';

  // Goals

  static const String goals = '/api/goals';

  static String goalDetails(int goalId) {
    return '/api/goals/$goalId';
  }

  // Leave

  static const String leaveHistory = '/api/leaves/leave-requests?lang=en';

  static const String leaveBalances = '/api/leaves/leave-balances?lang=en';

  static const String leaveRequests = '/api/leaves/leave-requests';

  // Career Coach

  static const String careerCoach = '/api/ai/career-coach';

  // Add project-specific endpoints below.
}
