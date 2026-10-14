import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/auth/forgot_password/domain/entities/forgot_password_entity.dart';

abstract class ForgotPasswordRepository {
  Future<Either<Failure, String>> sendOtp({required String email});
  
  Future<Either<Failure, ForgotPasswordEntity>> verifyOtp({
    required String email,
    required String otp,
  });
  
  Future<Either<Failure, String>> resendOtp({required String email});
}