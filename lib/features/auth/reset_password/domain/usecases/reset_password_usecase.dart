import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/auth/reset_password/domain/repositories/reset_password_repository.dart';

class ResetPasswordUseCase {
  final ResetPasswordRepository repository;
  ResetPasswordUseCase(this.repository);

  Future<Either<Failure, String>> call({
    required String resetToken,
    required String password,
    required String passwordConfirmation,
  }) async {
    return await repository.resetPassword(
      resetToken: resetToken,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
  }
}