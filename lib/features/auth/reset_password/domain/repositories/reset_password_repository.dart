import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';

abstract class ResetPasswordRepository {
  Future<Either<Failure, String>> resetPassword({
    required String resetToken,
    required String password,
    required String passwordConfirmation,
  });
}