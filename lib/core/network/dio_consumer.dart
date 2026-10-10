import 'package:dio/dio.dart';

import 'package:workwise/core/errors/exception.dart';

import 'api_consumer.dart';

class DioConsumer implements ApiConsumer {
  DioConsumer(this._dio);

  final Dio _dio;

  @override
  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<Response<dynamic>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<Response<dynamic>> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<Response<dynamic>> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<Response<dynamic>> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  AppException _handleDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkException(
          'Unable to connect to the server.',
        );

      case DioExceptionType.badResponse:
        return _handleStatusCode(
          exception.response?.statusCode,
          exception.response?.data,
        );

      case DioExceptionType.cancel:
        return const NetworkException(
          'Request was cancelled.',
        );

      case DioExceptionType.badCertificate:
        return const NetworkException(
          'Invalid server certificate.',
        );

      case DioExceptionType.unknown:
        return const NetworkException(
          'Something went wrong. Please try again.',
        );
      case DioExceptionType.transformTimeout:
        return const NetworkException(
          'The server response took too long to process.',
        );
    }
  }

  AppException _handleStatusCode(int? statusCode, dynamic responseData) {
    final responseMessage = _extractResponseMessage(responseData);

    switch (statusCode) {
      case 401:
        return UnauthorizedException(
          responseMessage ?? 'Unauthorized request.',
        );

      case 400:
      case 422:
        return ValidationException(
          responseMessage ?? 'Invalid request.',
        );

      case 403:
        return UnauthorizedException(
          responseMessage ?? 'You do not have permission to perform this action.',
        );

      case 404:
        return ServerException(
          responseMessage ?? 'Requested resource was not found.',
        );

      case 500:
      case 502:
      case 503:
      case 504:
        return ServerException(
          responseMessage ?? 'Server error. Please try again later.',
        );

      default:
        return ServerException(
          responseMessage ?? 'Something went wrong on the server.',
        );
    }
  }

  String? _extractResponseMessage(dynamic responseData) {
    if (responseData is! Map) {
      return null;
    }

    final message = responseData['message'];
    return message is String && message.trim().isNotEmpty ? message : null;
  }
}
