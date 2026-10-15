
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:workwise/core/errors/exception.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/core/storage/local_storage.dart';
import 'package:workwise/core/storage/secure_storage.dart';
import 'package:workwise/features/auth/login/data/datasources/login_api_service.dart';
import 'package:workwise/features/auth/login/data/models/login_response_model.dart';
import 'package:workwise/features/auth/login/domain/entities/login_entity.dart';
import 'package:workwise/features/auth/login/domain/repositories/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  LoginRepositoryImpl({
    required this.loginApiService,
    required this.secureStorage,
    required this.localStorage,
  });

  final LoginApiService loginApiService;
  final SecureStorage secureStorage;
  final LocalStorage localStorage;

  @override
  Future<Either<Failure, LoginDataEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await loginApiService.login(
        email: email,
        password: password,
      );

      if (response.data is! Map) {
        return const Left(
          ServerFailure('Invalid response received from the server.'),
        );
      }

      final responseData = Map<String, dynamic>.from(
        response.data as Map,
      );

      if (response.statusCode != 200 ||
          responseData['success'] != true) {
        return Left(
          ServerFailure(
            responseData['message']?.toString() ??
                'Unable to login. Please try again.',
          ),
        );
      }

      final loginModel = LoginResponseModel.fromJson(responseData);
      final loginData = loginModel.data;

      if (loginData.accessToken.isEmpty ||
          loginData.refreshToken.isEmpty) {
        return const Left(
          ServerFailure(
            'The server returned invalid authentication tokens.',
          ),
        );
      }

      await secureStorage.saveAccessToken(loginData.accessToken);
      await secureStorage.saveRefreshToken(loginData.refreshToken);
      await localStorage.saveUserId(loginData.user.id);

      return Right(loginData.toEntity());
    } on AppException catch (e) {
      return Left(_mapAppException(e));
    } on DioException catch (e) {
      return Left(_mapDioException(e));
    } on FormatException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(
        ServerFailure('Unable to login. Please try again.'),
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      await loginApiService.logout();
    } catch (_) {
      // Clear the local session even if the logout request fails.
    }

    await secureStorage.clearSession();
    await localStorage.clearSession();
  }

  Failure _mapAppException(AppException exception) {
    if (exception is NetworkException) {
      return NetworkFailure(exception.message);
    }

    if (exception is ValidationException) {
      return ValidationFailure(exception.message);
    }

    if (exception is UnauthorizedException) {
      return UnauthorizedFailure(exception.message);
    }

    if (exception is ServerException) {
      return ServerFailure(exception.message);
    }

    return const ServerFailure(
      'Something went wrong. Please try again.',
    );
  }

  Failure _mapDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure(
          'Unable to connect to the server. Please try again.',
        );

      default:
        break;
    }

    final response = exception.response;
    final data = response?.data;
    final message = data is Map
        ? data['message']?.toString()
        : null;

    switch (response?.statusCode) {
      case 401:
        return UnauthorizedFailure(
          message ?? 'Invalid email or password.',
        );

      case 403:
        return UnauthorizedFailure(
          message ?? 'Your account is inactive.',
        );

      case 422:
        return ValidationFailure(
          message ?? 'Please check the entered data.',
        );

      case 429:
        return ServerFailure(
          message ?? 'Too many attempts. Please try again later.',
        );

      case 500:
      case 502:
      case 503:
      case 504:
        return ServerFailure(
          message ?? 'Server error. Please try again later.',
        );

      default:
        return NetworkFailure(
          exception.message ?? 'A network error occurred.',
        );
    }
  }
}
