import 'package:pretty_dio_logger/pretty_dio_logger.dart';

PrettyDioLogger createPrettyDioLogger() {
  return PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseHeader: false,
    responseBody: false,
    error: true,
    compact: true,
    maxWidth: 120,
  );
}
