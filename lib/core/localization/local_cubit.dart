import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workwise/core/constants/storage_keys.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit(SharedPreferences preferences)
      : _preferences = preferences,
        super(
          _localeFromCode(
            preferences.getString(StorageKeys.locale),
          ),
        );

  final SharedPreferences _preferences;

  Future<void> setLocale(Locale locale) async {
    if (!_isSupported(locale) || locale == state) {
      return;
    }

    emit(locale);

    await _preferences.setString(
      StorageKeys.locale,
      locale.languageCode,
    );
  }

  static Locale _localeFromCode(String? languageCode) {
    return _supportedLanguageCodes.contains(languageCode)
        ? Locale(languageCode!)
        : const Locale('en');
  }

  static bool _isSupported(Locale locale) {
    return _supportedLanguageCodes.contains(locale.languageCode);
  }

  static const _supportedLanguageCodes = <String>{
    'en',
    'ar',
  };
}