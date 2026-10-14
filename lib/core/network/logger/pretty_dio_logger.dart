import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

PrettyDioLogger createPrettyDioLogger() {
  return PrettyDioLogger(
    requestHeader: false,
    requestBody: false,
    responseHeader: false,
    responseBody: false,
    error: true,
    compact: false,
    maxWidth: 120,
    enabled: kDebugMode,
  );
}

