abstract final class ApiEndpoints {
  // Attendance
  static const String todayAttendance = '/api/attendance/today';
  static const String checkIn = '/api/attendance/check-in';
  static const String checkOut = '/api/attendance/check-out';
  static const String attendanceHistory = '/api/attendance/history';

  // Notifications
  static const String notifications = '/api/notifications';
  static const String unreadNotificationsCount =
      '/api/notifications/unread-count';
  static const String markAllNotificationsAsRead =
      '/api/notifications/read-all';
  static const String clearAllNotifications = '/api/notifications/clear-all';

  static String markNotificationAsRead(String id) =>
      '/api/notifications/$id/read';

  static String deleteNotification(String id) => '/api/notifications/$id';

  static String deleteFile(int fileId) => '/api/files/$fileId';

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

  // Tasks
  static const String tasks = '/api/tasks';
  static String taskById(int id) => '/api/tasks/$id';
  static String updateTaskProgress(int id) => '/api/tasks/$id/progress';
  static String updateTaskStatus(int id) => '/api/tasks/$id/status';
  static String submitTask(int id) => '/api/tasks/$id/submissions';
  static String getSubmissionDetails(int submissionId) => '/api/tasks/submissions/$submissionId';
  static String addSubmissionAttachment(int submissionId) => '/api/tasks/submissions/$submissionId/attachments';
  static String resubmitSubmission(int submissionId) => '/api/tasks/submissions/$submissionId/resubmit';

  // Add project-specific endpoints below.
  static const String employeeProfile = '/api/employees/profile';

  static String employeeDetails(int employeeId) {
    return '/api/employees/$employeeId';
  }
}
