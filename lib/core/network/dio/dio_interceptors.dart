import 'dart:developer';

import 'package:dio/dio.dart';

class DioInterceptors extends Interceptor {
  DioInterceptors({
    this.getToken,
  });

  final String? Function()? getToken;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final token = getToken?.call();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    log(
      'Dio Error: ${err.message}',
      name: 'DioInterceptor',
      error: err.error,
      stackTrace: err.stackTrace,
    );

    handler.next(err);
  }
}