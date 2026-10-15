import 'package:dio/dio.dart';
import 'package:workwise/core/network/api_consumer.dart';
import 'package:workwise/core/network/endpoints/api_endpoints.dart';

class ForgotPasswordApiService {
  ForgotPasswordApiService(this._apiConsumer);

  final ApiConsumer _apiConsumer;

  Future<Response<dynamic>> sendOtp({
    required String email,
  }) {
    return _apiConsumer.post(
      ApiEndpoints.forgetPassword,
      queryParameters: const {
        'lang': 'en',
      },
      options: Options(
        headers: const {
          'Accept-Language': 'en',
        },
      ),
      data: {
        'email': email,
      },
    );
  }

  Future<Response<dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) {
    return _apiConsumer.post(
      ApiEndpoints.verifyOtp,
      queryParameters: const {
        'lang': 'en',
      },
      options: Options(
        headers: const {
          'Accept-Language': 'en',
        },
      ),
      data: {
        'email': email,
        'otp': otp,
      },
    );
  }

  Future<Response<dynamic>> resendOtp({
    required String email,
  }) {
    return _apiConsumer.post(
      ApiEndpoints.resendOtp,
      queryParameters: const {
        'lang': 'en',
      },
      options: Options(
        headers: const {
          'Accept-Language': 'en',
        },
      ),
      data: {
        'email': email,
      },
    );
  }
}
