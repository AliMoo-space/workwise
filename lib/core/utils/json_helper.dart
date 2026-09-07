import 'package:workwise/core/errors/exception.dart';

class JsonHelper {
  const JsonHelper._();

  static T required<T>(Map<String, dynamic> json, String key) {
    final value = json[key];

    if (value == null) {
      throw ServerException('Missing required field: $key');
    }

    return value as T;
  }

  static T? optional<T>(Map<String, dynamic> json, String key) {
    return json[key] as T?;
  }
}
