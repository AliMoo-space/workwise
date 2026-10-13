import 'package:dio/dio.dart';

class ErrorMessage {
  static String fromDioException(DioException e) {
    final responseData = e.response?.data;

    // Message returned from server
    if (responseData is Map<String, dynamic>) {
      final message = responseData['message'];

      if (message is String && message.trim().isNotEmpty) {
        return message;
      }
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please try again.';

      case DioExceptionType.sendTimeout:
        return 'Request timeout. Please try again.';

      case DioExceptionType.receiveTimeout:
        return 'Server is taking too long to respond. Please try again.';

      case DioExceptionType.transformTimeout:
        return 'Request processing took too long. Please try again.';

      case DioExceptionType.connectionError:
        return 'Unable to connect to the server. Please check your internet connection.';

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;

        switch (statusCode) {
          case 400:
            return 'Invalid request. Please check your data.';

          case 401:
            return 'Your session has expired. Please login again.';

          case 403:
            return 'You do not have permission to perform this action.';

          case 404:
            return 'The requested resource was not found.';

          case 422:
            return 'Some of the entered data is invalid.';

          case 500:
          case 502:
          case 503:
          case 504:
            return 'Server error. Please try again later.';

          default:
            return 'Something went wrong. Please try again.';
        }

      case DioExceptionType.cancel:
        return 'Request was cancelled.';

      case DioExceptionType.badCertificate:
        return 'Unable to establish a secure connection.';

      case DioExceptionType.unknown:
        return 'Something went wrong. Please try again.';
    }
  }
}
