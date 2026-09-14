// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get hello => 'Hello';

  @override
  String get welcome => 'Welcome';

  @override
  String get goodbye => 'Goodbye';

  @override
  String get thank_you => 'Thank you';

  @override
  String get yes => 'Yes';

  @override
  String get signIn => 'Sign In';

  @override
  String get signInContent => 'Sign In Content';

  @override
  String get language => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'Arabic';

  @override
  String get loading => 'loading...';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get signInWithCorporateCredentials =>
      'Sign in with your corporate credentials';

  @override
  String get workEmail => 'Work Email';

  @override
  String get workEmailHint => 'name@company.com';

  @override
  String get password => 'Password';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get keepMeSignedIn => 'Keep me signed in';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get quickSignIn => 'Quick Sign-In';

  @override
  String get useFingerprintOrFaceId => 'Use Fingerprint or Face ID';

  @override
  String get or => 'OR';

  @override
  String get sessionExpiredWarning =>
      'Your session has expired. Please try again to continue.';

  @override
  String get invalidCredentialsWarning =>
      'Invalid credentials. Please try again.';

  @override
  String get verifyYourIdentityToAccessYourAccount =>
      'Verify your identity to access your account';

  @override
  String get tapToScanFingerprintFaceID => 'Tap to scan Fingerprint / Face ID';

  @override
  String get useEmailAndPasswordInstead => 'Use email and password instead';

  @override
  String get biometricsNotAvailable =>
      'Biometric authentication is not available on this device.';

  @override
  String get authCanceledOrFailed => 'Authentication canceled or failed.';

  @override
  String get resetPasswordTitle => 'Reset Password';

  @override
  String get resetPasswordDescription =>
      'Enter your work email and we\'ll send you a reset link.';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get enterWorkEmailMessage => 'Please enter your work email';

  @override
  String get invalidEmailFormatMessage => 'Invalid work email format';

  @override
  String get enterPasswordMessage => 'Please enter your password';
}
