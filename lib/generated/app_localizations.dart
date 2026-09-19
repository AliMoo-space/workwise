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

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'loading...'**
  String get loading;

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

  /// No description provided for @aiHrAssistant.
  ///
  /// In en, this message translates to:
  /// **'AI HR Assistant'**
  String get aiHrAssistant;

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

  /// No description provided for @leave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leave;

  /// No description provided for @balancesRequestsGoals.
  ///
  /// In en, this message translates to:
  /// **'Balances, requests, and personal goals'**
  String get balancesRequestsGoals;

  /// No description provided for @leaveType.
  ///
  /// In en, this message translates to:
  /// **'Leave type'**
  String get leaveType;

  /// No description provided for @selectLeaveType.
  ///
  /// In en, this message translates to:
  /// **'Select type...'**
  String get selectLeaveType;

  /// No description provided for @annualLeave.
  ///
  /// In en, this message translates to:
  /// **'Annual Leave'**
  String get annualLeave;

  /// No description provided for @casualLeave.
  ///
  /// In en, this message translates to:
  /// **'Casual Leave'**
  String get casualLeave;

  /// No description provided for @sickLeave.
  ///
  /// In en, this message translates to:
  /// **'Sick Leave'**
  String get sickLeave;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get endDate;

  /// No description provided for @reason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reason;

  /// No description provided for @reasonHint.
  ///
  /// In en, this message translates to:
  /// **'Briefly describe your reason...'**
  String get reasonHint;

  /// No description provided for @attachSupportingDocument.
  ///
  /// In en, this message translates to:
  /// **'Attach supporting document'**
  String get attachSupportingDocument;

  /// No description provided for @uploadImage.
  ///
  /// In en, this message translates to:
  /// **'Upload image'**
  String get uploadImage;

  /// No description provided for @submitRequest.
  ///
  /// In en, this message translates to:
  /// **'Submit request'**
  String get submitRequest;

  /// No description provided for @leaveHistory.
  ///
  /// In en, this message translates to:
  /// **'Leave history'**
  String get leaveHistory;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @atAGlance.
  ///
  /// In en, this message translates to:
  /// **'At a glance'**
  String get atAGlance;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get goodMorning;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'THIS MONTH'**
  String get thisMonth;

  /// No description provided for @yourPerformance.
  ///
  /// In en, this message translates to:
  /// **'Your performance'**
  String get yourPerformance;

  /// No description provided for @fromLastMonth.
  ///
  /// In en, this message translates to:
  /// **'from last month'**
  String get fromLastMonth;

  /// No description provided for @overall.
  ///
  /// In en, this message translates to:
  /// **'overall'**
  String get overall;

  /// No description provided for @quality.
  ///
  /// In en, this message translates to:
  /// **'Quality'**
  String get quality;

  /// No description provided for @april.
  ///
  /// In en, this message translates to:
  /// **'Apr'**
  String get april;

  /// No description provided for @may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// No description provided for @june.
  ///
  /// In en, this message translates to:
  /// **'Jun'**
  String get june;

  /// No description provided for @july.
  ///
  /// In en, this message translates to:
  /// **'Jul'**
  String get july;

  /// No description provided for @august.
  ///
  /// In en, this message translates to:
  /// **'Aug'**
  String get august;

  /// No description provided for @september.
  ///
  /// In en, this message translates to:
  /// **'Sep'**
  String get september;

  /// No description provided for @performanceTrend.
  ///
  /// In en, this message translates to:
  /// **'Performance trend'**
  String get performanceTrend;

  /// No description provided for @personalGoals.
  ///
  /// In en, this message translates to:
  /// **'Personal goals'**
  String get personalGoals;

  /// No description provided for @target.
  ///
  /// In en, this message translates to:
  /// **'Target:'**
  String get target;

  /// No description provided for @onTrack.
  ///
  /// In en, this message translates to:
  /// **'On Track'**
  String get onTrack;

  /// No description provided for @aiAssistant.
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get aiAssistant;

  /// No description provided for @careerCoachingHrPolicySupport.
  ///
  /// In en, this message translates to:
  /// **'Career coaching & HR policy support'**
  String get careerCoachingHrPolicySupport;

  /// No description provided for @careerCoach.
  ///
  /// In en, this message translates to:
  /// **'Career Coach'**
  String get careerCoach;

  /// No description provided for @policyAssistant.
  ///
  /// In en, this message translates to:
  /// **'Policy Assistant'**
  String get policyAssistant;

  /// No description provided for @actionPlan.
  ///
  /// In en, this message translates to:
  /// **'Action plan'**
  String get actionPlan;

  /// No description provided for @developmentAreas.
  ///
  /// In en, this message translates to:
  /// **'Development areas'**
  String get developmentAreas;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @biometricLogin.
  ///
  /// In en, this message translates to:
  /// **'Biometric login'**
  String get biometricLogin;

  /// No description provided for @fingerprintFaceId.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint / Face ID'**
  String get fingerprintFaceId;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push notifications'**
  String get pushNotifications;

  /// No description provided for @tasksApprovalsReminders.
  ///
  /// In en, this message translates to:
  /// **'Tasks, approvals, reminders'**
  String get tasksApprovalsReminders;

  /// No description provided for @appDisplayLanguage.
  ///
  /// In en, this message translates to:
  /// **'App display language'**
  String get appDisplayLanguage;

  /// No description provided for @logoutConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutConfirmationMessage;
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
