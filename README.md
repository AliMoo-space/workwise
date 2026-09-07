# workwise

Workwise Flutter application.

## Localization

The application supports English and Arabic localization.

- English locale: `en`
- Arabic locale: `ar`
- Translation files: `lib/l10n/app_en.arb` and `lib/l10n/app_ar.arb`
- Generated localization class: `AppLocalizations`
- Localization configuration: `l10n.yaml`

Flutter localization is configured with `flutter_localizations` and `intl`.
The generated localization files are stored in `lib/generated/`.

### Language Switching

The language selector is available from the application bar. It uses the
existing Bloc architecture through `LocaleCubit` and updates the application
locale immediately.

The selected language is persisted with `shared_preferences`, so it remains
selected after the application is restarted. Arabic automatically uses the
right-to-left text direction, while English uses the left-to-right direction.

### Updating Translations

1. Add the same translation key to both ARB files.
2. Run localization generation:

```bash
flutter gen-l10n
```

3. Use the generated strings in widgets:

```dart
final localizations = AppLocalizations.of(context);
Text(localizations.exampleKey);
```

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
# Flutter
