
import 'package:dio/dio.dart';
import 'package:workwise/core/network/dio/dio_interceptors.dart';
import 'package:workwise/core/network/logger/pretty_dio_logger.dart';

class DioFactory {
  DioFactory({required this.baseUrl, this.getToken});

  final String baseUrl;
final Future<String?> Function()? getToken;
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
          'Accept-Language': 'en',
        },
      ),
    );

    dio.interceptors.add(createPrettyDioLogger());
    dio.interceptors.add(DioInterceptors(getToken: getToken));

    return dio;
  }
}
