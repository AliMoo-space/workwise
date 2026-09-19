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




