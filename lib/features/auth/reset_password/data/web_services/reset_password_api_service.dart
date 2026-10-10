import 'package:dio/dio.dart';
import 'package:workwise/core/network/api_consumer.dart';
import 'package:workwise/core/network/endpoints/api_endpoints.dart';

class ResetPasswordApiService {
  ResetPasswordApiService(this._apiConsumer);

  final ApiConsumer _apiConsumer;

  Future<Response<dynamic>> resetPassword({
    required String resetToken,
    required String password,
    required String passwordConfirmation,
  }) {
    return _apiConsumer.post(
      ApiEndpoints.resetPassword,
      queryParameters: const {'lang': 'en'},
      options: Options(headers: const {'Accept-Language': 'en'}),
      data: {
        'reset_token': resetToken,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );
  }
}