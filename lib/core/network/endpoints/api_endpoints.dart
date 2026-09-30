abstract final class ApiEndpoints {
  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh-token';
  static const String logout = '/auth/logout';

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
}
