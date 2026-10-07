import 'dart:developer';

import 'package:dio/dio.dart';

class DioInterceptors extends Interceptor {
  DioInterceptors({this.getToken});

  final Future<String?> Function()? getToken;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await getToken?.call();

      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e, stackTrace) {
      log(
        'Failed to read access token.',
        name: 'DioInterceptor',
        error: e,
        stackTrace: stackTrace,
      );
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log(
      'Dio Error: ${err.message}',
      name: 'DioInterceptor',
      error: err.error,
      stackTrace: err.stackTrace,
    );

    handler.next(err);
  }
}