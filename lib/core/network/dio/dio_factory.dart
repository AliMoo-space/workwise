import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:workwise/core/network/dio/dio_interceptors.dart';
import 'package:workwise/core/network/logger/pretty_dio_logger.dart';
import 'package:workwise/core/storage/local_storage.dart';
import 'package:workwise/core/storage/secure_storage.dart';

class DioFactory {
  DioFactory({
    required this.baseUrl,
    this.getToken,
    required this.localStorage,
    required this.secureStorage,
  });

  final String baseUrl;
  final Future<String?> Function()? getToken;
  final LocalStorage localStorage;
  final SecureStorage secureStorage;

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


if (kDebugMode) {
  dio.interceptors.add(createPrettyDioLogger());
}
    dio.interceptors.add(
      DioInterceptors(
        getToken: getToken,
        localStorage: localStorage,
        secureStorage: secureStorage,
        baseUrl: baseUrl,
      ),
    );

    return dio;
  }
}
