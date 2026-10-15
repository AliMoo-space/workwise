import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/auth/reset_password/data/datasources/reset_password_api_service.dart';
import 'package:workwise/features/auth/reset_password/domain/repositories/reset_password_repository.dart';

class ResetPasswordRepositoryImpl implements ResetPasswordRepository {
  ResetPasswordRepositoryImpl({
    required this.resetPasswordApiService,
  });

  final ResetPasswordApiService resetPasswordApiService;

  @override
  Future<Either<Failure, String>> resetPassword({
    required String resetToken,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await resetPasswordApiService.resetPassword(
        resetToken: resetToken,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

      final responseData = response.data as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return Right(
          responseData['message']?.toString() ?? 'Password reset successfully.',
        );
      }

      return Left(
        ServerFailure(
          responseData['message']?.toString() ?? 'Something went wrong.',
        ),
      );
    } on DioException catch (e) {
      return Left(_mapDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Failure _mapDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure('Connection error occurred.');
      default:
        break;
    }
    
    final response = exception.response;
    if (response != null && response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      return ServerFailure(data['message']?.toString() ?? 'Something went wrong.');
    }
    
    return NetworkFailure(exception.message ?? 'Network error occurred.');
  }
}