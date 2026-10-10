import 'package:workwise/core/errors/exception.dart';
import 'package:workwise/core/network/api_consumer.dart';
import 'package:workwise/core/network/endpoints/api_endpoints.dart';
import 'package:workwise/features/attendance/data/models/attendance_history_model.dart';

abstract interface class AttendanceHistoryRemoteDataSource {
  Future<AttendanceHistoryPageModel> getHistory({
    int? month,
    int? year,
    int? perPage,
  });
}

class AttendanceHistoryRemoteDataSourceImpl
    implements AttendanceHistoryRemoteDataSource {
  const AttendanceHistoryRemoteDataSourceImpl({required this._apiConsumer});

  final ApiConsumer _apiConsumer;

  @override
  Future<AttendanceHistoryPageModel> getHistory({
    int? month,
    int? year,
    int? perPage,
  }) async {
    final queryParameters = <String, dynamic>{
      ...?month == null ? null : {'month': month},
      ...?year == null ? null : {'year': year},
      ...?perPage == null ? null : {'per_page': perPage},
    };
    final response = await _apiConsumer.get(
      ApiEndpoints.attendanceHistory,
      queryParameters: queryParameters.isEmpty ? null : queryParameters,
    );
    final responseData = response.data;
    if (responseData is! Map || responseData['data'] is! Map) {
      throw const ServerException(
        'Invalid response format: missing data field',
      );
    }
    return AttendanceHistoryPageModel.fromJson(
      Map<String, dynamic>.from(responseData['data'] as Map),
    );
  }
}
