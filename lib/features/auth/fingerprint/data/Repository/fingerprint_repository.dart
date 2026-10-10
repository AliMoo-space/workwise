
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/core/storage/secure_storage.dart';
import 'package:workwise/features/auth/fingerprint/data/models/toggle_biometric_response_model.dart';
import 'package:workwise/features/auth/fingerprint/data/web_services/fingerprint_api_service.dart';
import 'package:workwise/features/auth/login/data/models/login_response_model.dart';

class FingerprintRepository {
  FingerprintRepository({
    required this.fingerprintApiService,
    required this.secureStorage,
  });

  final FingerprintApiService fingerprintApiService;
  final SecureStorage secureStorage;
  Future<bool> hasBiometricToken() async {
  final token = await secureStorage.getBiometricToken();
  return token != null && token.isNotEmpty;
}

  Future<Either<Failure, ToggleBiometricResponseModel>>
      toggleBiometrics() async {
    try {
      final response =
          await fingerprintApiService.toggleBiometrics();

      final responseData =
          Map<String, dynamic>.from(response.data as Map);

      final model =
          ToggleBiometricResponseModel.fromJson(responseData);

      if (response.statusCode != 200 || !model.success) {
        return Left(ServerFailure(model.message));
      }

      if (model.data.isEnabled) {
        final token = model.data.biometricToken;

        if (token == null || token.isEmpty) {
          return const Left(
            ServerFailure(
              'The server did not return a biometric token.',
            ),
          );
        }

        await secureStorage.saveBiometricToken(token);
      } else {
        await secureStorage.removeBiometricToken();
      }

      return Right(model);
    } on DioException catch (e) {
  if (e.response?.statusCode == 401) {
    await secureStorage.removeBiometricToken();
  }
  return Left(_mapDioException(e));
}
  }

  Future<Either<Failure, LoginResponseModel>>
      biometricLogin() async {
    try {
      final biometricToken =
          await secureStorage.getBiometricToken();

      if (biometricToken == null || biometricToken.isEmpty) {
        return const Left(
          ServerFailure(
            'Biometric login is not enabled. Please sign in with your email and password.',
          ),
        );
      }

      final response =
          await fingerprintApiService.biometricLogin(
        biometricToken: biometricToken,
      );

      final responseData =
          Map<String, dynamic>.from(response.data as Map);

      final model = LoginResponseModel.fromJson(responseData);

      if (response.statusCode != 200 || !model.success) {
        return Left(ServerFailure(model.message));
      }

      await secureStorage.saveAccessToken(
        model.data.accessToken,
      );

      return Right(model);
    } on DioException catch (e) {
      return Left(_mapDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Failure _mapDioException(DioException exception) {
    final response = exception.response;
    final data = response?.data;

    if (data is Map) {
      final message = data['message']?.toString();

      switch (response?.statusCode) {
        case 401:
          return UnauthorizedFailure(
            message ?? 'Authentication failed.',
          );

        case 403:
          return UnauthorizedFailure(
            message ?? 'Your account is inactive.',
          );

        case 422:
          return ValidationFailure(
            message ?? 'The provided data is invalid.',
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

    switch (exception.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure(
          'Unable to connect to the server. Please try again.',
        );

      default:
        return NetworkFailure(
          exception.message ?? 'Network error occurred.',
        );
    }
  }
}