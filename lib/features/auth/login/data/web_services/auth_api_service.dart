import 'package:dio/dio.dart';
import 'package:workwise/core/network/api_consumer.dart';
import 'package:workwise/core/network/endpoints/api_endpoints.dart';

class AuthApiService {
  AuthApiService(this._apiConsumer);

  final ApiConsumer _apiConsumer;

  Future<Response<dynamic>> login({
    required String email,
    required String password,
  }) {
    return _apiConsumer.post(
      ApiEndpoints.login,
      queryParameters: const {'lang': 'en'},
      options: Options(headers: const {'Accept-Language': 'en'}),
      data: {'email': email, 'password': password},
    );
  }

  Future<Response<dynamic>> logout() {
    return _apiConsumer.post(ApiEndpoints.logout);
  }
}
