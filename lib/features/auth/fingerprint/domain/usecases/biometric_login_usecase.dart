import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/auth/fingerprint/domain/repositories/fingerprint_repository.dart';
import 'package:workwise/features/auth/login/domain/entities/login_entity.dart';

class BiometricLoginUseCase {
  final FingerprintRepository repository;
  BiometricLoginUseCase(this.repository);

  Future<Either<Failure, LoginDataEntity>> call() async {
    return await repository.biometricLogin();
  }
}