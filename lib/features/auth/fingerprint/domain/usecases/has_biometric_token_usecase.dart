import 'package:workwise/features/auth/fingerprint/domain/repositories/fingerprint_repository.dart';

class HasBiometricTokenUseCase {
  final FingerprintRepository repository;
  HasBiometricTokenUseCase(this.repository);

  Future<bool> call() async {
    return await repository.hasBiometricToken();
  }
}