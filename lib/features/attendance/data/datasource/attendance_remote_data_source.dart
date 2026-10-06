import 'package:workwise/core/errors/exception.dart';
import 'package:workwise/core/network/api_consumer.dart';
import 'package:workwise/core/network/endpoints/api_endpoints.dart';
import 'package:workwise/features/attendance/data/models/attendance_action_model.dart';
import 'package:workwise/features/attendance/data/models/attendance_model.dart';

abstract interface class AttendanceRemoteDataSource {
  Future<AttendanceModel> getTodayAttendance({
    required double latitude,
    required double longitude,
  });
  Future<AttendanceActionModel> checkIn({
    required double latitude,
    required double longitude,
  });
  Future<AttendanceActionModel> checkOut({double? latitude, double? longitude});
}

class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDataSource {
  AttendanceRemoteDataSourceImpl({required this._apiConsumer});

  final ApiConsumer _apiConsumer;

  @override
  Future<AttendanceModel> getTodayAttendance({
    required double latitude,
    required double longitude,
  }) async {
    final response = await _apiConsumer.get(
      ApiEndpoints.todayAttendance,
      queryParameters: {'latitude': latitude, 'longitude': longitude},
    );
    final data = _extractData(response.data);
    return AttendanceModel.fromJson(data);
  }

  @override
  Future<AttendanceActionModel> checkIn({
    required double latitude,
    required double longitude,
  }) async {
    final response = await _apiConsumer.post(
      ApiEndpoints.checkIn,
      data: {'latitude': latitude, 'longitude': longitude},
    );
    final data = _extractData(response.data);
    return AttendanceActionModel.fromJson(data);
  }

  @override
  Future<AttendanceActionModel> checkOut({
    double? latitude,
    double? longitude,
  }) async {
    final response = await _apiConsumer.post(ApiEndpoints.checkOut);
    final data = _extractData(response.data);
    return AttendanceActionModel.fromJson(data);
  }

  Map<String, dynamic> _extractData(dynamic responseData) {
    if (responseData is Map) {
      final data = responseData['data'];
      if (data is Map) {
        return Map<String, dynamic>.from(data);
      }
    }
    throw const ServerException('Invalid response format: missing data field');
  }
}
