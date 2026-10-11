import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:workwise/core/storage/local_storage.dart';

class DioInterceptors extends Interceptor {
  DioInterceptors({
    this.getToken,
    required this.localStorage,
  });

  final Future<String?> Function()? getToken;
  final LocalStorage localStorage;

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

      options.headers['Accept-Language'] =
          localStorage.getLocale();
    } catch (e, stackTrace) {
      log(
        'Failed to prepare request headers.',
        name: 'DioInterceptor',
        error: e,
        stackTrace: stackTrace,
      );
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
      'Dio Error: ${err.response?.statusCode ?? 'no status'} '
      '${err.response?.data ?? err.message}',
      name: 'DioInterceptor',
      error: err.error,
      stackTrace: err.stackTrace,
    );

    handler.next(err);
  }
}