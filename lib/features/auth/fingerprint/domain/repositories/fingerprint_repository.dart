import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/auth/fingerprint/domain/entities/biometric_entity.dart';
import 'package:workwise/features/auth/login/domain/entities/login_entity.dart';

abstract class FingerprintRepository {
  Future<bool> hasBiometricToken();
  
  Future<Either<Failure, BiometricEntity>> toggleBiometrics();
  
  Future<Either<Failure, LoginDataEntity>> biometricLogin();
}