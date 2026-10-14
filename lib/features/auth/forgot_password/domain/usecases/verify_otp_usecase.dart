import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/auth/forgot_password/domain/entities/forgot_password_entity.dart';
import 'package:workwise/features/auth/forgot_password/domain/repositories/forgot_password_repository.dart';

class VerifyOtpUseCase {
  final ForgotPasswordRepository repository;
  VerifyOtpUseCase(this.repository);

  Future<Either<Failure, ForgotPasswordEntity>> call({
    required String email,
    required String otp,
  }) async {
    return await repository.verifyOtp(email: email, otp: otp);
  }
}