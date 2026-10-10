
import 'package:dio/dio.dart';
import 'package:workwise/core/network/api_consumer.dart';
import 'package:workwise/core/network/endpoints/api_endpoints.dart';

class FingerprintApiService {
  FingerprintApiService(this._apiConsumer);

  final ApiConsumer _apiConsumer;

  Future<Response<dynamic>> toggleBiometrics() {
    return _apiConsumer.post(
      ApiEndpoints.toggleBiometrics,
      queryParameters: const {
        'lang': 'en',
      },
      options: Options(
        headers: const {
          'Accept-Language': 'en',
        },
      ),
    );
  }

  Future<Response<dynamic>> biometricLogin({
    required String biometricToken,
  }) {
    return _apiConsumer.post(
      ApiEndpoints.biometricLogin,
      queryParameters: const {
        'lang': 'en',
      },
      options: Options(
        headers: const {
          'Accept-Language': 'en',
        },
      ),
      data: {
        'biometric_token': biometricToken,
      },
    );
  }
}