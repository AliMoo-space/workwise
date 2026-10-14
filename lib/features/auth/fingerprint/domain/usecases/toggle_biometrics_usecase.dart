import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/auth/fingerprint/domain/entities/biometric_entity.dart';
import 'package:workwise/features/auth/fingerprint/domain/repositories/fingerprint_repository.dart';

class ToggleBiometricsUseCase {
  final FingerprintRepository repository;
  ToggleBiometricsUseCase(this.repository);

  Future<Either<Failure, BiometricEntity>> call() async {
    return await repository.toggleBiometrics();
  }
}