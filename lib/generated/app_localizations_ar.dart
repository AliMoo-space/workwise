// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get hello => 'مرحبا';

  @override
  String get welcome => 'أهلا وسهلا';

  @override
  String get goodbye => 'مع السلامة';

  @override
  String get thank_you => 'شكرا';

  @override
  String get yes => 'نعم';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get signInContent => 'محتوى تسجيل الدخول';

  @override
  String get language => 'اللغة';

  @override
  String get languageEnglish => 'الإنجليزية';

  @override
  String get languageArabic => 'العربية';

  @override
  String get tasks => 'المهام';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get settings => 'الإعدادات';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get submit => 'إرسال';

  @override
  String get cancel => 'إلغاء';

  @override
  String get trackAssignments => 'تتبع المهام وإرسالها للمراجعة';

  @override
  String get all => 'الكل';

  @override
  String get inProgress => 'قيد التنفيذ';

  @override
  String get underReview => 'قيد المراجعة';

  @override
  String get completed => 'مكتملة';

  @override
  String get noTasksHere => 'لا توجد مهام هنا';

  @override
  String get noTasksMessage => 'لا توجد مهام في هذا الفلتر حالياً.';

  @override
  String get submitForReview => 'إرسال للمراجعة';

  @override
  String get notes => 'ملاحظات';

  @override
  String get notesHint => 'أضف ملاحظة لمديرك...';

  @override
  String get attachments => 'المرفقات';

  @override
  String get tapToUpload => 'اضغط لرفع ملف';

  @override
  String get fileFormatsSupported => 'PDF, DOCX, PNG حتى 10 ميجا';

  @override
  String get removeAttachment => 'حذف المرفق';

  @override
  String get taskSubmittedSuccess => 'تم إرسال المهمة للمراجعة.';

  @override
  String get due => 'الموعد النهائي';

  @override
  String managerFeedback(String feedback) {
    return 'ملاحظات المدير: $feedback';
  }

  @override
  String get low => 'منخفضة';

  @override
  String get medium => 'متوسطة';

  @override
  String get high => 'عالية';

  @override
  String get urgent => 'عاجلة';
}
