import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/auth/login/domain/entities/login_entity.dart';

abstract class LoginRepository {
  Future<Either<Failure, LoginDataEntity>> login({
    required String email,
    required String password,
  });

  Future<void> logout();
}