import 'package:workwise/features/auth/fingerprint/domain/repositories/fingerprint_repository.dart';

class GetBiometricSettingUseCase {
  const GetBiometricSettingUseCase(this.repository);

  final FingerprintRepository repository;

  Future<bool> call() async {
    return await repository.hasBiometricToken();
  }
}