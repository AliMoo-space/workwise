
import 'package:dio/dio.dart';
import 'package:workwise/core/network/dio/dio_interceptors.dart';
import 'package:workwise/core/network/logger/pretty_dio_logger.dart';
import 'package:workwise/core/storage/local_storage.dart';

class DioFactory {
  DioFactory({
  required this.baseUrl,
  this.getToken,
  required this.localStorage,
});

final String baseUrl;
final Future<String?> Function()? getToken;
final LocalStorage localStorage;
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

  dio.interceptors.add(createPrettyDioLogger());

  dio.interceptors.add(
    DioInterceptors(
      getToken: getToken,
      localStorage: localStorage,
    ),
  );

  return dio;
}
}
