# Team Notes

> الحاجات اللي اتغيرت + الحاجات اللي محتاجين ناخد بالنا منها عشان محدش يتلغبط.

---

## 1. Architecture

### ⚠️ مهم جدًا

أي Feature جديدة **لازم تلتزم بالـ structure ده:**

```text
auth/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
│
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
│
└── presentation/
    ├── cubit/
    ├── screens/
    └── widgets/
```

**ممنوع تغيير أسماء الـ folders أو عمل structure مختلف.**

---

## 2. Core

قبل ما تعمل أي Widget أو Component جديد:

* دور الأول في `core`
* لو فيه حاجة مشابهة استخدمها
* متعملش نفس الـ component مرة تانية داخل الـ feature

---

## 3. Localization

استخدم الـ extension الموجودة هنا:

[`lib/core/localization/localization_extension.dart`](lib/core/localization/localization_extension.dart)

بدل:

```dart
final localization = AppLocalizations.of(context);

Text(
  localization.or,
)
```

استخدم مباشرة:

```dart
Text(
  context.l10.or,
)
```

### ❌ متعملش

```dart
final localization = AppLocalizations.of(context);
```

### ✅ استخدم

```dart
context.l10.translationKey
```

---

## 4. Changes

### Core / General

* [`service_locator.dart`](lib/core/services/service_locator.dart)

  * استخدم الـ Service Locator الموجود هنا.

* [`locale_provider.dart`](lib/core/localization/locale_provider.dart)

  * ❌ تم حذف الملف، ملوش لازمة.

* [`app_theme.dart`](lib/core/design_system/theme/app_theme.dart)

  * اتضافت Comments بالعربي على الحاجات اللي اتغيرت.

* [`app_text_styles.dart`](lib/core/design_system/typography/app_text_styles.dart)

  * اتضافت Comments بالعربي على الحاجات اللي اتغيرت.

* [`app_button.dart`](lib/core/design_system/widgets/buttons/app_button.dart)

  * اتضافت Comments بالعربي على الحاجات اللي اتغيرت.

---

# Zeyad

### Localization

استخدم:

```dart
context.l10.translationKey
```

بدل:

```dart
final localization = AppLocalizations.of(context);
```

### Login

* [ ] ظبط لون الـ Login
* [ ] حل مشكلة الـ Error اللي بيظهر أول ما ندوس على Login
* [ ] ظبط انتقال الـ Fingerprint عشان يظهر الـ Bottom Navigation Bar
* [ ] ظبط الـ Forgot Password

---

# Ahmed

### Job Detail

في:

[`lib/features/profile/widgets/job_detail_item.dart`](lib/features/profile/widgets/job_detail_item.dart)

تم حذف `fontSize`.

استخدم الـ `AppTextStyle` بدل `fontSize` مباشرة.

### Main

* [ ] شيل الـ Notifier من `main.dart`
* [ ] خلي الـ UI يستخدم static data

### Core

استخدم الـ components الموجودة في `core` بدل ما تعمل components مشابهة جوه الـ feature.

---

# Abo_Khalil

* [ ] Add your changes here
* [ ] Add any important notes هنا



import 'package:go_router/go_router.dart';
import 'package:workwise/core/routing/app_routes.dart';
import 'package:workwise/core/routing/page_transition.dart';
import 'package:workwise/features/auth/fingerprint/presentation/screens/finger_print_screen.dart';
import 'package:workwise/features/auth/forgot_password/presentation/screens/otp_verification_screen.dart';
import 'package:workwise/features/auth/login/presentation/screens/login_screen.dart';
import 'package:workwise/features/auth/reset_password/presentation/screens/create_new_passwors_screen.dart';
import 'package:workwise/features/home/presentation/screens/home_screen.dart';
import 'package:workwise/features/main/presentation/screens/main_screen.dart';
import 'package:workwise/features/setting/presentation/screens/settings_screen.dart';
import 'package:workwise/features/splash/presentation/screens/splash_screen.dart';
import 'package:workwise/features/tasks/presentation/screens/tasks_screen.dart';

class RouterGenerationConfig {
  static GoRouter goRouter = GoRouter(
    initialLocation: AppRoutes.splashScreen,
    routes: [
      GoRoute(
        name: AppRoutes.mainScreen,
        path: AppRoutes.mainScreen,
        pageBuilder: (context, state) =>
            slideTransitionPage(state: state, child: const MainScreen()),
      ),
      GoRoute(
        name: AppRoutes.splashScreen,
        path: AppRoutes.splashScreen,
        pageBuilder: (context, state) =>
            noTransitionPage(state: state, child: const SplashScreen()),
      ),
      GoRoute(
        name: AppRoutes.loginScreen,
        path: AppRoutes.loginScreen,
        pageBuilder: (context, state) =>
            slideTransitionPage(state: state, child: const LoginScreen()),
      ),
      GoRoute(
        name: AppRoutes.otpVerificationScreen,
        path: AppRoutes.otpVerificationScreen,
        pageBuilder: (context, state) {
          final email = state.extra as String? ?? '';
          return slideTransitionPage(
            state: state,
            child: OtpVerificationScreen(email: email),
          );
        },
      ),
      GoRoute(
        name: AppRoutes.createNewPasswordScreen,
        path: AppRoutes.createNewPasswordScreen,
        pageBuilder: (context, state) {
          final email = state.extra as String? ?? '';
          return slideTransitionPage(
            state: state,
            child: CreateNewPasswordScreen(email: email),
          );
        },
      ),
      GoRoute(
        name: AppRoutes.fingerprintScreen,
        path: AppRoutes.fingerprintScreen,
        pageBuilder: (context, state) =>
            slideTransitionPage(state: state, child: const FingerPrintScreen()),
      ),
      GoRoute(
        name: AppRoutes.homeScreen,
        path: AppRoutes.homeScreen,
        pageBuilder: (context, state) =>
            slideTransitionPage(state: state, child: const HomeScreen()),
      ),
      GoRoute(
        name: AppRoutes.tasksScreen,
        path: AppRoutes.tasksScreen,
        pageBuilder: (context, state) =>
            slideTransitionPage(state: state, child: const TasksScreen()),
      ),
      GoRoute(
        name: AppRoutes.settingsScreen,
        path: AppRoutes.settingsScreen,
        pageBuilder: (context, state) =>
            slideTransitionPage(state: state, child: const SettingsScreen()),
      ),
    ],
  );
}

