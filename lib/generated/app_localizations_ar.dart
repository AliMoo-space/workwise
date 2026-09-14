// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get hello => 'مرحباً';

  @override
  String get welcome => 'أهلاً وسهلاً';

  @override
  String get goodbye => 'مع السلامة';

  @override
  String get thank_you => 'شكراً';

  @override
  String get yes => 'نعم';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get signInContent => 'محتوى تسجيل الدخول';

  @override
  String get language => 'اللغة';

  @override
  String get languageEnglish => 'الإنجليزيّة';

  @override
  String get languageArabic => 'العربيّة';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get welcomeBack => 'مرحباً بعودتك';

  @override
  String get signInWithCorporateCredentials =>
      'سجّل الدخول باستخدام بيانات حساب الشركة';

  @override
  String get workEmail => 'البريد الإلكتروني للعمل';

  @override
  String get workEmailHint => 'name@company.com';

  @override
  String get password => 'كلمة المرور';

  @override
  String get passwordHint => 'أدخل كلمة المرور';

  @override
  String get keepMeSignedIn => 'الاحتفاظ بتسجيل الدخول';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get quickSignIn => 'تسجيل دخول سريع';

  @override
  String get useFingerprintOrFaceId => 'استخدم بصمة الإصبع أو الوجه';

  @override
  String get or => 'أو';

  @override
  String get sessionExpiredWarning =>
      'انتهت الجلسة الخاصة بك. يرجى إعادة محاولة الدخول للمتابعة.';

  @override
  String get invalidCredentialsWarning =>
      'بيانات الدخول غير صحيحة. يرجى المحاولة مرة أخرى.';

  @override
  String get verifyYourIdentityToAccessYourAccount =>
      'تأكيد الهوية للوصول إلى حسابك';

  @override
  String get tapToScanFingerprintFaceID => 'انقر للمسح ببصمة الإصبع / الوجه';

  @override
  String get useEmailAndPasswordInstead =>
      'استخدم البريد الإلكتروني وكلمة المرور بدلاً من ذلك';

  @override
  String get biometricsNotAvailable =>
      'التحقق بالبصمة غير متوفر على هذا الجهاز.';

  @override
  String get authCanceledOrFailed => 'تم إلغاء عملية التحقق أو فشلت.';

  @override
  String get resetPasswordTitle => 'إعادة ضبط كلمة المرور';

  @override
  String get resetPasswordDescription =>
      'أدخل بريد العمل وسنرسل لك رابطاً لإعادة الضبط.';

  @override
  String get sendResetLink => 'إرسال رابط الضبط';

  @override
  String get enterWorkEmailMessage => 'يرجى إدخال بريد العمل الإلكتروني';

  @override
  String get invalidEmailFormatMessage => 'صيغة بريد العمل غير صحيحة';

  @override
  String get enterPasswordMessage => 'يرجى إدخال كلمة المرور';
}
