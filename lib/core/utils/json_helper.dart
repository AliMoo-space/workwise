import 'package:workwise/core/errors/exception.dart';

abstract final class JsonHelper {
  const JsonHelper._();

  static T required<T>(
    Map<String, dynamic> json,
    String key,
  ) {
    final value = json[key];

    if (value == null) {
      throw ServerException(
        'Missing required field: $key',
      );
    }

    if (value is! T) {
      throw ServerException(
        'Invalid type for field: $key',
      );
    }

    return value;
  }

  static T? optional<T>(
    Map<String, dynamic> json,
    String key,
  ) {
    final value = json[key];

    if (value == null) {
      return null;
    }

    if (value is! T) {
      throw ServerException(
        'Invalid type for field: $key',
      );
    }

    return value;
  }
}