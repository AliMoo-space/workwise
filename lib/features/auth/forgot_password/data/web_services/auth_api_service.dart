import 'package:dio/dio.dart';
import 'package:workwise/core/network/api_consumer.dart';
import 'package:workwise/core/network/endpoints/api_endpoints.dart';

class AuthApiService {
  AuthApiService(this._apiConsumer);
  final ApiConsumer _apiConsumer;
  Future<Response<dynamic>> sendOtp({required String email}) {
    return _apiConsumer.post(
      ApiEndpoints.forgetPassword,
      queryParameters: const {'lang': 'en'},
      options: Options(headers: const {'Accept-Language': 'en'}),
      data: {'email': email},
    );
  }
}
