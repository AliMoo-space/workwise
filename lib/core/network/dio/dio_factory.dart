import 'package:dio/dio.dart';

import '../logger/pretty_dio_logger.dart';
import 'dio_interceptors.dart';

class DioFactory {
  DioFactory({
    required this.baseUrl,
    this.getToken,
  });

  final String baseUrl;
  final String? Function()? getToken;

  Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      DioInterceptors(
        getToken: getToken,
      ),
    );

    dio.interceptors.add(
      createPrettyDioLogger(),
    );

    return dio;
  }
}