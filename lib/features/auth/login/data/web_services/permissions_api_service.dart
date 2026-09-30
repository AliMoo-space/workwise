import 'package:dio/dio.dart';
import 'package:workwise/core/network/api_consumer.dart';

class PermissionsApiService {
  PermissionsApiService(this._apiConsumer);

  final ApiConsumer _apiConsumer;

  Future<Response<dynamic>> getPermissions() {
    return _apiConsumer.get(
      '/api/permissions',
    );
  }
}
