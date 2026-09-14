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
  String get tasks => 'Tasks';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get logout => 'Logout';

  @override
  String get submit => 'Submit';

  @override
  String get cancel => 'Cancel';

  @override
  String get trackAssignments => 'Track assignments and submit for review';

  @override
  String get all => 'All';

  @override
  String get inProgress => 'In Progress';

  @override
  String get underReview => 'Under Review';

  @override
  String get completed => 'Completed';

  @override
  String get noTasksHere => 'No tasks here';

  @override
  String get noTasksMessage => 'There are no tasks in this filter right now.';

  @override
  String get submitForReview => 'Submit for Review';

  @override
  String get notes => 'Notes';

  @override
  String get notesHint => 'Add a note for your manager...';

  @override
  String get attachments => 'Attachments';

  @override
  String get tapToUpload => 'Tap to upload a file';

  @override
  String get fileFormatsSupported => 'PDF, DOCX, PNG up to 10MB';

  @override
  String get removeAttachment => 'Remove attachment';

  @override
  String get taskSubmittedSuccess => 'Task submitted for review.';

  @override
  String get due => 'Due';

  @override
  String managerFeedback(String feedback) {
    return 'Manager feedback: $feedback';
  }

  @override
  String get low => 'Low';

  @override
  String get medium => 'Medium';

  @override
  String get high => 'High';

  @override
  String get urgent => 'Urgent';
}
