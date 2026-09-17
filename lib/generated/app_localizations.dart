import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @goodbye.
  ///
  /// In en, this message translates to:
  /// **'Goodbye'**
  String get goodbye;

  /// No description provided for @thank_you.
  ///
  /// In en, this message translates to:
  /// **'Thank you'**
  String get thank_you;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signInContent.
  ///
  /// In en, this message translates to:
  /// **'Sign In Content'**
  String get signInContent;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get languageArabic;

  /// No description provided for @homeScreen.
  ///
  /// In en, this message translates to:
  /// **'Home Screen'**
  String get homeScreen;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @todayAttendance.
  ///
  /// In en, this message translates to:
  /// **'Today\'s attendance'**
  String get todayAttendance;

  /// No description provided for @onShift.
  ///
  /// In en, this message translates to:
  /// **'On Shift'**
  String get onShift;

  /// No description provided for @checkedInAt.
  ///
  /// In en, this message translates to:
  /// **'Checked in at 9:00 AM'**
  String get checkedInAt;

  /// No description provided for @hoursWorked.
  ///
  /// In en, this message translates to:
  /// **'hours worked'**
  String get hoursWorked;

  /// No description provided for @insideOffice.
  ///
  /// In en, this message translates to:
  /// **'Inside the office'**
  String get insideOffice;

  /// No description provided for @checkOut.
  ///
  /// In en, this message translates to:
  /// **'Check Out'**
  String get checkOut;

  /// No description provided for @pendingTasks.
  ///
  /// In en, this message translates to:
  /// **'Pending Tasks'**
  String get pendingTasks;

  /// No description provided for @nextMeeting.
  ///
  /// In en, this message translates to:
  /// **'Next Meeting'**
  String get nextMeeting;

  /// No description provided for @leaveBalance.
  ///
  /// In en, this message translates to:
  /// **'Leave Balance'**
  String get leaveBalance;

  /// No description provided for @requestLeave.
  ///
  /// In en, this message translates to:
  /// **'Request Leave'**
  String get requestLeave;

  /// No description provided for @submitTask.
  ///
  /// In en, this message translates to:
  /// **'Submit Task'**
  String get submitTask;

  /// No description provided for @viewCalendar.
  ///
  /// In en, this message translates to:
  /// **'View Calendar'**
  String get viewCalendar;

  /// No description provided for @aiHrAssistant.
  ///
  /// In en, this message translates to:
  /// **'AI HR Assistant'**
  String get aiHrAssistant;

  /// No description provided for @drawerHeader.
  ///
  /// In en, this message translates to:
  /// **'Drawer Header'**
  String get drawerHeader;

  /// No description provided for @drawerItem1.
  ///
  /// In en, this message translates to:
  /// **'Item 1'**
  String get drawerItem1;

  /// No description provided for @drawerItem2.
  ///
  /// In en, this message translates to:
  /// **'Item 2'**
  String get drawerItem2;

  /// No description provided for @drawerItem3.
  ///
  /// In en, this message translates to:
  /// **'Item 3'**
  String get drawerItem3;

  /// No description provided for @attendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get attendance;

  /// No description provided for @attendanceDescription.
  ///
  /// In en, this message translates to:
  /// **'Location-validated check in and history'**
  String get attendanceDescription;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @june2026.
  ///
  /// In en, this message translates to:
  /// **'June 2026'**
  String get june2026;

  /// No description provided for @insideWorkplaceRadius.
  ///
  /// In en, this message translates to:
  /// **'Inside workplace radius'**
  String get insideWorkplaceRadius;

  /// No description provided for @gpsAccuracy.
  ///
  /// In en, this message translates to:
  /// **'GPS accuracy +/-8m - 42m to office'**
  String get gpsAccuracy;

  /// No description provided for @valid.
  ///
  /// In en, this message translates to:
  /// **'Valid'**
  String get valid;

  /// No description provided for @present.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get present;

  /// No description provided for @late.
  ///
  /// In en, this message translates to:
  /// **'Late'**
  String get late;

  /// No description provided for @attendanceDate1.
  ///
  /// In en, this message translates to:
  /// **'Mon, Jun 09'**
  String get attendanceDate1;

  /// No description provided for @attendanceDetails1.
  ///
  /// In en, this message translates to:
  /// **'08:45 AM - 05:32 PM  -  8h 47m'**
  String get attendanceDetails1;

  /// No description provided for @attendanceDate2.
  ///
  /// In en, this message translates to:
  /// **'Fri, Jun 06'**
  String get attendanceDate2;

  /// No description provided for @attendanceDetails2.
  ///
  /// In en, this message translates to:
  /// **'09:18 AM - 05:40 PM  -  8h 22m'**
  String get attendanceDetails2;

  /// No description provided for @attendanceDate3.
  ///
  /// In en, this message translates to:
  /// **'Thu, Jun 05'**
  String get attendanceDate3;

  /// No description provided for @attendanceDetails3.
  ///
  /// In en, this message translates to:
  /// **'08:52 AM - 05:28 PM  -  8h 36m'**
  String get attendanceDetails3;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'loading...'**
  String get loading;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @signInWithCorporateCredentials.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your corporate credentials'**
  String get signInWithCorporateCredentials;

  /// No description provided for @workEmail.
  ///
  /// In en, this message translates to:
  /// **'Work Email'**
  String get workEmail;

  /// No description provided for @workEmailHint.
  ///
  /// In en, this message translates to:
  /// **'name@company.com'**
  String get workEmailHint;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @keepMeSignedIn.
  ///
  /// In en, this message translates to:
  /// **'Keep me signed in'**
  String get keepMeSignedIn;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @quickSignIn.
  ///
  /// In en, this message translates to:
  /// **'Quick Sign-In'**
  String get quickSignIn;

  /// No description provided for @useFingerprintOrFaceId.
  ///
  /// In en, this message translates to:
  /// **'Use Fingerprint or Face ID'**
  String get useFingerprintOrFaceId;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @sessionExpiredWarning.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please try again to continue.'**
  String get sessionExpiredWarning;

  /// No description provided for @invalidCredentialsWarning.
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials. Please try again.'**
  String get invalidCredentialsWarning;

  /// No description provided for @verifyYourIdentityToAccessYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Verify your identity to access your account'**
  String get verifyYourIdentityToAccessYourAccount;

  /// No description provided for @tapToScanFingerprintFaceID.
  ///
  /// In en, this message translates to:
  /// **'Tap to scan Fingerprint / Face ID'**
  String get tapToScanFingerprintFaceID;

  /// No description provided for @useEmailAndPasswordInstead.
  ///
  /// In en, this message translates to:
  /// **'Use email and password instead'**
  String get useEmailAndPasswordInstead;

  /// No description provided for @biometricsNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication is not available on this device.'**
  String get biometricsNotAvailable;

  /// No description provided for @authCanceledOrFailed.
  ///
  /// In en, this message translates to:
  /// **'Authentication canceled or failed.'**
  String get authCanceledOrFailed;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter your work email and we\'ll send you a reset link.'**
  String get resetPasswordDescription;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @enterWorkEmailMessage.
  ///
  /// In en, this message translates to:
  /// **'Please enter your work email'**
  String get enterWorkEmailMessage;

  /// No description provided for @invalidEmailFormatMessage.
  ///
  /// In en, this message translates to:
  /// **'Invalid work email format'**
  String get invalidEmailFormatMessage;

  /// No description provided for @enterPasswordMessage.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get enterPasswordMessage;

  /// No description provided for @tasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasks;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @trackAssignments.
  ///
  /// In en, this message translates to:
  /// **'Track assignments and submit for review'**
  String get trackAssignments;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// No description provided for @underReview.
  ///
  /// In en, this message translates to:
  /// **'Under Review'**
  String get underReview;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @noTasksHere.
  ///
  /// In en, this message translates to:
  /// **'No tasks here'**
  String get noTasksHere;

  /// No description provided for @noTasksMessage.
  ///
  /// In en, this message translates to:
  /// **'There are no tasks in this filter right now.'**
  String get noTasksMessage;

  /// No description provided for @submitForReview.
  ///
  /// In en, this message translates to:
  /// **'Submit for Review'**
  String get submitForReview;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'Add a note for your manager...'**
  String get notesHint;

  /// No description provided for @attachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get attachments;

  /// No description provided for @tapToUpload.
  ///
  /// In en, this message translates to:
  /// **'Tap to upload a file'**
  String get tapToUpload;

  /// No description provided for @fileFormatsSupported.
  ///
  /// In en, this message translates to:
  /// **'PDF, DOCX, PNG up to 10MB'**
  String get fileFormatsSupported;

  /// No description provided for @removeAttachment.
  ///
  /// In en, this message translates to:
  /// **'Remove attachment'**
  String get removeAttachment;

  /// No description provided for @taskSubmittedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Task submitted for review.'**
  String get taskSubmittedSuccess;

  /// No description provided for @due.
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get due;

  /// No description provided for @managerFeedback.
  ///
  /// In en, this message translates to:
  /// **'Manager feedback: {feedback}'**
  String managerFeedback(String feedback);

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @urgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get urgent;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
