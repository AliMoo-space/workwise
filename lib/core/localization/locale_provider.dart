import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  LocaleProvider(SharedPreferences preferences)
      : _preferences = preferences,
        _locale = _localeFromCode(preferences.getString(_localeKey));

  static const _localeKey = 'locale';
  final SharedPreferences _preferences;
  Locale _locale;

  Locale get locale => _locale;

  Future<void> setLocale(Locale locale) async {
    if (!_isSupported(locale) || locale == _locale) {
      return;
    }

    _locale = locale;
    notifyListeners();
    await _preferences.setString(_localeKey, locale.languageCode);
  }

  static Locale _localeFromCode(String? languageCode) {
    return _supportedLanguageCodes.contains(languageCode)
        ? Locale(languageCode!)
        : const Locale('en');
  }

  static bool _isSupported(Locale locale) {
    return _supportedLanguageCodes.contains(locale.languageCode);
  }

  static const _supportedLanguageCodes = <String>{'en', 'ar'};
}
