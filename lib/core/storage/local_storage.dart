import 'package:shared_preferences/shared_preferences.dart';
import 'package:workwise/core/constants/storage_keys.dart';

class LocalStorage {
  LocalStorage(this._preferences);

  final SharedPreferences _preferences;

  Future<bool> saveAccessToken(String token) {
    return _preferences.setString(
      StorageKeys.accessToken,
      token,
    );
  }

  String? getAccessToken() {
    return _preferences.getString(
      StorageKeys.accessToken,
    );
  }

  Future<bool> removeAccessToken() {
    return _preferences.remove(
      StorageKeys.accessToken,
    );
  }

  Future<bool> saveUserId(int userId) {
    return _preferences.setInt(
      StorageKeys.userId,
      userId,
    );
  }

  int? getUserId() {
    return _preferences.getInt(
      StorageKeys.userId,
    );
  }


Future<bool> saveKeepMeSignedIn(bool value) {
  return _preferences.setBool(
    StorageKeys.keepMeSignedIn,
    value,
  );
}

bool getKeepMeSignedIn() {
  return _preferences.getBool(
        StorageKeys.keepMeSignedIn,
      ) ??
      false;
}

Future<bool> removeKeepMeSignedIn() {
  return _preferences.remove(
    StorageKeys.keepMeSignedIn,
  );
}



  Future<bool> clearSession() async {
    await _preferences.remove(StorageKeys.accessToken);
    await _preferences.remove(StorageKeys.refreshToken);
    await _preferences.remove(StorageKeys.userId);

    return true;
  }
}