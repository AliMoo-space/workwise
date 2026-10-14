
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:workwise/core/network/endpoints/api_endpoints.dart';
import 'package:workwise/core/storage/local_storage.dart';
import 'package:workwise/core/storage/secure_storage.dart';
import 'package:workwise/core/utils/json_helper.dart';

class DioInterceptors extends Interceptor {
  DioInterceptors({
    this.getToken,
    required this.localStorage,
    required this.secureStorage,
    required this.baseUrl,
  });

  final Future<String?> Function()? getToken;
  final LocalStorage localStorage;
  final SecureStorage secureStorage;
  final String baseUrl;

  Future<String?>? _refreshFuture;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final isAuthEndpoint = _isAuthEndpoint(options.path);

      // Public authentication requests should not use an old access token.
      if (isAuthEndpoint) {
        options.headers.remove('Authorization');
      } else {
        final token = await getToken?.call();

        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
      }

      options.headers['Accept-Language'] = localStorage.getLocale();

      debugPrint(
        '[NETWORK][REQUEST] ${options.method} ${options.path}',
      );
      debugPrint(
        '[NETWORK][REQUEST] Authorization attached: '
        '${options.headers.containsKey('Authorization')}',
      );
      debugPrint(
        '[NETWORK][REQUEST] Language: '
        '${options.headers['Accept-Language']}',
      );
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
    debugPrint(
      '[NETWORK][RESPONSE] ${response.requestOptions.method} '
      '${response.requestOptions.path} '
      'Status: ${response.statusCode}',
    );

    handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;
    final statusCode = err.response?.statusCode;

    // Never print tokens, credentials, or authentication response bodies.
    debugPrint(
      '[NETWORK][ERROR] ${request.method} ${request.path} '
      'Status: ${statusCode ?? 'no status'} '
      'Type: ${err.type}',
    );
    debugPrint('[NETWORK][ERROR] Message: ${err.message}');

    if (statusCode != 401 ||
        request.extra['retryAfterRefresh'] == true ||
        _isAuthEndpoint(request.path)) {
      handler.next(err);
      return;
    }

    debugPrint('[AUTH][REFRESH] Request returned 401.');

    try {
      final newAccessToken = await _getRefreshedAccessToken();

      if (newAccessToken == null || newAccessToken.isEmpty) {
        debugPrint(
          '[AUTH][RETRY] Cancelled: refresh did not provide an access token.',
        );
        handler.next(err);
        return;
      }

      request.headers['Authorization'] = 'Bearer $newAccessToken';
      request.extra['retryAfterRefresh'] = true;

      final retryDio = Dio(
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

      try {
        debugPrint('[AUTH][RETRY] Retrying original request once.');

        final response = await retryDio.fetch<dynamic>(request);

        debugPrint(
          '[AUTH][RETRY] Completed. Status: ${response.statusCode}',
        );

        handler.resolve(response);
      } on DioException catch (e) {
        debugPrint(
          '[AUTH][RETRY] Failed. '
          'Status: ${e.response?.statusCode ?? 'no status'} '
          'Type: ${e.type}',
        );

        handler.reject(e);
      } finally {
        retryDio.close(force: true);
      }
    } catch (e, stackTrace) {
      log(
        'Failed to refresh or retry the original request.',
        name: 'DioInterceptor',
        error: e,
        stackTrace: stackTrace,
      );

      handler.next(err);
    }
  }

  bool _isAuthEndpoint(String path) {
    final normalizedPath = Uri.parse(path).path;

    return normalizedPath == ApiEndpoints.login ||
        normalizedPath == ApiEndpoints.biometricLogin ||
        normalizedPath == ApiEndpoints.refresh;
  }

  Future<String?> _getRefreshedAccessToken() {
    return _refreshFuture ??= _refreshAccessToken().whenComplete(() {
      _refreshFuture = null;
    });
  }

  Future<String?> _refreshAccessToken() async {
    debugPrint('[AUTH][REFRESH] ===== STARTED =====');

    try {
      final refreshToken = await secureStorage.getRefreshToken();

      debugPrint(
        '[AUTH][REFRESH] Refresh token exists: '
        '${refreshToken != null && refreshToken.isNotEmpty}',
      );

      if (refreshToken == null || refreshToken.isEmpty) {
        debugPrint('[AUTH][REFRESH] Aborted: refresh token is missing.');
        return null;
      }

      final refreshDio = Dio(
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

      try {
        debugPrint('[AUTH][REFRESH] Sending refresh request.');

        final response = await refreshDio.post<dynamic>(
          ApiEndpoints.refresh,
          data: {'refresh_token': refreshToken},
          options: Options(
            headers: {
              'Accept-Language': localStorage.getLocale(),
            },
          ),
        );

        debugPrint(
          '[AUTH][REFRESH] Response status: ${response.statusCode}',
        );

        if (response.data is! Map) {
          throw const FormatException(
            'Invalid refresh response format.',
          );
        }

        final responseData = Map<String, dynamic>.from(
          response.data as Map,
        );

        if (responseData['success'] != true) {
          final message = responseData['message']?.toString();

          throw FormatException(
            message == null || message.isEmpty
                ? 'Token refresh was not successful.'
                : message,
          );
        }

        final data = JsonHelper.required<Map<String, dynamic>>(
          responseData,
          'data',
        );

        final newAccessToken = JsonHelper.required<String>(
          data,
          'access_token',
        );

        final newRefreshToken = JsonHelper.required<String>(
          data,
          'refresh_token',
        );

        if (newAccessToken.isEmpty || newRefreshToken.isEmpty) {
          throw const FormatException(
            'Refresh response contains an empty token.',
          );
        }

        // Save both rotated tokens before retrying the failed request.
        await secureStorage.saveAccessToken(newAccessToken);
        await secureStorage.saveRefreshToken(newRefreshToken);

        debugPrint('[AUTH][REFRESH] Access token saved.');
        debugPrint('[AUTH][REFRESH] Refresh token rotated and saved.');

        final newBiometricToken = JsonHelper.optional<String>(
          data,
          'biometric_token',
        );

        if (newBiometricToken != null &&
            newBiometricToken.isNotEmpty) {
          await secureStorage.saveBiometricToken(newBiometricToken);
          debugPrint('[AUTH][REFRESH] Biometric token updated.');
        }

        debugPrint('[AUTH][REFRESH] ===== COMPLETED =====');

        return newAccessToken;
      } finally {
        refreshDio.close(force: true);
      }
    } catch (e, stackTrace) {
      log(
        'Refresh token operation failed.',
        name: 'DioInterceptor',
        error: e,
        stackTrace: stackTrace,
      );

      Error.throwWithStackTrace(e, stackTrace);
    }
  }
}
