import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/core/network/network_info.dart';
import 'package:workwise/core/storage/local_storage.dart';
import 'package:workwise/core/storage/secure_storage.dart';
import 'package:workwise/features/auth/login/data/models/login_response_model.dart';
import 'package:workwise/features/auth/login/data/web_services/auth_api_service.dart';

class AuthRepository {
  AuthRepository({
    required this.authApiService,
    required this.networkInfo,
    required this.secureStorage,
    required this.localStorage,
  });

  final AuthApiService authApiService;
  final NetworkInfo networkInfo;
  final SecureStorage secureStorage;
  final LocalStorage localStorage;

  Future<Either<Failure, LoginResponseModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await authApiService.login(
        email: email,
        password: password,
      );

      final responseData = response.data as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final loginModel = LoginResponseModel.fromJson(responseData);

        await secureStorage.saveAccessToken(loginModel.data.accessToken);
        await localStorage.saveUserId(loginModel.data.user.id);

        return Right(loginModel);
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
          case 403:
            return UnauthorizedFailure(message ?? 'Your account is inactive.');
          case 422:
            return ValidationFailure(
              message ?? 'The provided credentials are invalid.',
            );
          case 429:
            return ServerFailure(message ?? 'Too many login attempts.');
          case 500:
            return ServerFailure(message ?? 'Something went wrong.');
        }
        return ServerFailure(message ?? 'Something went wrong.');
      }
    }
    return NetworkFailure(exception.message ?? 'Network error occurred.');
  }
}
