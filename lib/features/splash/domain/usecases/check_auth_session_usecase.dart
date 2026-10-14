import 'package:workwise/core/storage/local_storage.dart';
import 'package:workwise/core/storage/secure_storage.dart';

class CheckAuthSessionUseCase {
  CheckAuthSessionUseCase({
    required this.secureStorage,
    required this.localStorage,
  });

  final SecureStorage secureStorage;
  final LocalStorage localStorage;

  Future<bool> call() async {
    final accessToken = await secureStorage.getAccessToken();
    final keepMeSignedIn = localStorage.getKeepMeSignedIn();

    return accessToken != null && accessToken.isNotEmpty && keepMeSignedIn;
  }
}