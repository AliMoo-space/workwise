import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/auth/reset_password/data/web_services/reset_password_api_service.dart';

class ResetPasswordRepository {
  ResetPasswordRepository({
    required this.resetPasswordApiService,
  });

  final ResetPasswordApiService resetPasswordApiService;

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
          responseData['message']?.toString() ??
              'Password reset successfully.',
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
        return const NetworkFailure(
          'Unable to connect to the server. Please check your internet connection and try again.',
        );

      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure(
          'Connection timed out. Please check your internet connection and try again.',
        );

      default:
        break;
    }

    final response = exception.response;

    if (response != null) {
      final data = response.data;

      if (data is Map<String, dynamic>) {
        final message = data['message']?.toString();

        switch (response.statusCode) {
          case 422:
            return ValidationFailure(
              message ?? 'The provided data is invalid.',
            );

          case 429:
            return ServerFailure(
              message ?? 'Too many requests. Please try again later.',
            );

          case 500:
            return ServerFailure(
              message ?? 'Something went wrong.',
            );
        }

        return ServerFailure(
          message ?? 'Something went wrong.',
        );
      }
    }

    return NetworkFailure(
      exception.message ?? 'Network error occurred.',
    );
  }
}
