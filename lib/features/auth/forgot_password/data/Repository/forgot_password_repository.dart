import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/auth/forgot_password/data/models/forgot_password_response_model.dart';
import 'package:workwise/features/auth/forgot_password/data/web_services/forgot_password_api_service.dart';

class ForgotPasswordRepository {
  ForgotPasswordRepository({
    required this.forgotPasswordApiService,
  });

  final ForgotPasswordApiService forgotPasswordApiService;

  Future<Either<Failure, String>> sendOtp({
    required String email,
  }) async {
    try {
      final response = await forgotPasswordApiService.sendOtp(
        email: email,
      );

      final responseData = response.data as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return Right(
          responseData['message']?.toString() ??
              'OTP sent successfully.',
        );
      }

      return Left(
        ServerFailure(
          responseData['message']?.toString() ??
              'Something went wrong.',
        ),
      );
    } on DioException catch (e) {
      return Left(_mapDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, ForgotPasswordResponseModel>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await forgotPasswordApiService.verifyOtp(
        email: email,
        otp: otp,
      );

      final responseData = response.data as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final model = ForgotPasswordResponseModel.fromJson(
          responseData,
        );

        return Right(model);
      }

      return Left(
        ServerFailure(
          responseData['message']?.toString() ??
              'Something went wrong.',
        ),
      );
    } on DioException catch (e) {
      return Left(_mapDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, String>> resendOtp({
    required String email,
  }) async {
    try {
      final response = await forgotPasswordApiService.resendOtp(
        email: email,
      );

      final responseData = response.data as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return Right(
          responseData['message']?.toString() ??
              'OTP resent successfully.',
        );
      }

      return Left(
        ServerFailure(
          responseData['message']?.toString() ??
              'Something went wrong.',
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
      final errors = data['errors'];

      if (errors is Map<String, dynamic>) {
        final emailErrors = errors['email'];

        if (emailErrors is List && emailErrors.isNotEmpty) {
          return ValidationFailure(
            emailErrors.first.toString(),
          );
        }
      }

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
}}