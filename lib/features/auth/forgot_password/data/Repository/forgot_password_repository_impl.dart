import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/auth/forgot_password/data/models/forgot_password_response_model.dart';
import 'package:workwise/features/auth/forgot_password/data/datasources/forgot_password_api_service.dart';
import 'package:workwise/features/auth/forgot_password/domain/entities/forgot_password_entity.dart';
import 'package:workwise/features/auth/forgot_password/domain/repositories/forgot_password_repository.dart';

class ForgotPasswordRepositoryImpl implements ForgotPasswordRepository {
  ForgotPasswordRepositoryImpl({
    required this.forgotPasswordApiService,
  });

  final ForgotPasswordApiService forgotPasswordApiService;

  @override
  Future<Either<Failure, String>> sendOtp({required String email}) async {
    try {
      final response = await forgotPasswordApiService.sendOtp(email: email);
      final responseData = response.data as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return Right(responseData['message']?.toString() ?? 'OTP sent successfully.');
      }
      return Left(ServerFailure(responseData['message']?.toString() ?? 'Something went wrong.'));
    } on DioException catch (e) {
      return Left(_mapDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ForgotPasswordEntity>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await forgotPasswordApiService.verifyOtp(email: email, otp: otp);
      final responseData = response.data as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final model = ForgotPasswordResponseModel.fromJson(responseData);
        return Right(model.data.toEntity());
      }
      return Left(ServerFailure(responseData['message']?.toString() ?? 'Something went wrong.'));
    } on DioException catch (e) {
      return Left(_mapDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> resendOtp({required String email}) async {
    try {
      final response = await forgotPasswordApiService.resendOtp(email: email);
      final responseData = response.data as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return Right(responseData['message']?.toString() ?? 'OTP resent successfully.');
      }
      return Left(ServerFailure(responseData['message']?.toString() ?? 'Something went wrong.'));
    } on DioException catch (e) {
      return Left(_mapDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Failure _mapDioException(DioException exception) {
    // نفس معالجة الـ DioException القديمة
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