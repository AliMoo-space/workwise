import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:workwise/core/constants/storage_keys.dart';

class SecureStorage {
  SecureStorage(this._storage);

  final FlutterSecureStorage _storage;

  Future<void> saveAccessToken(String token) {
    return _storage.write(
      key: StorageKeys.accessToken,
      value: token,
    );
  }

  Future<String?> getAccessToken() {
    return _storage.read(
      key: StorageKeys.accessToken,
    );
  }

  Future<void> removeAccessToken() {
    return _storage.delete(
      key: StorageKeys.accessToken,
    );
  }

  Future<void> saveBiometricToken(String token) {
    return _storage.write(
      key: StorageKeys.biometricToken,
      value: token,
    );
  }

  Future<String?> getBiometricToken() {
    return _storage.read(
      key: StorageKeys.biometricToken,
    );
  }

  Future<void> removeBiometricToken() {
    return _storage.delete(
      key: StorageKeys.biometricToken,
    );
  }

  Future<void> clearSession() async {
    await _storage.delete(
      key: StorageKeys.accessToken,
    );

    await _storage.delete(
      key: StorageKeys.refreshToken,
    );
  }
}