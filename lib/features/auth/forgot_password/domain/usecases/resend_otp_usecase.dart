import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/auth/forgot_password/domain/repositories/forgot_password_repository.dart';

class ResendOtpUseCase {
  final ForgotPasswordRepository repository;
  ResendOtpUseCase(this.repository);

  Future<Either<Failure, String>> call({required String email}) async {
    return await repository.resendOtp(email: email);
  }
}