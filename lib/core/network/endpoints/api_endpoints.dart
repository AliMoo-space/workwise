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
}
