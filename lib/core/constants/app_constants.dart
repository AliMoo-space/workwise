abstract final class AppConstants {
  const AppConstants._();
  static const String baseUrl = 'https://your-api.com/api';

  static const String appName = 'WorkWise';

  static const Duration networkTimeout = Duration(seconds: 30);

  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);

  static const int maxImageSizeInMb = 5;

  static const String defaultLanguage = 'en';
}
