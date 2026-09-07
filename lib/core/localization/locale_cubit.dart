import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit(SharedPreferences preferences)
    : _preferences = preferences,
      super(_localeFromCode(preferences.getString(_localeKey)));

  static const _localeKey = 'locale';
  final SharedPreferences _preferences;

  Future<void> setLocale(Locale locale) async {
    if (!_isSupported(locale) || locale == state) {
      return;
    }

    emit(locale);
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
