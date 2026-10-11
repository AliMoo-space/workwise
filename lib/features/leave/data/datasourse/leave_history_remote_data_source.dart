import 'package:dio/dio.dart';
import 'package:workwise/core/network/api_consumer.dart';
import 'package:workwise/core/network/endpoints/api_endpoints.dart';
import 'package:workwise/core/network/error_message.dart';

import '../models/leave_history_model.dart';

abstract interface class LeaveHistoryRemoteDataSource {
  Future<List<LeaveHistoryModel>> getLeaveRequests();
}

class LeaveHistoryRemoteDataSourceImpl implements LeaveHistoryRemoteDataSource {
  const LeaveHistoryRemoteDataSourceImpl({required this.apiConsumer});

  final ApiConsumer apiConsumer;

  @override
  Future<List<LeaveHistoryModel>> getLeaveRequests() async {
    try {
      final response = await apiConsumer.get(ApiEndpoints.leaveRequests);

      final data = response.data['data'];

      if (data is! List) {
        throw const FormatException('Invalid leave history response format');
      }

      return data
          .map(
            (json) => LeaveHistoryModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } on DioException catch (e) {
      throw Exception(ErrorMessage.fromDioException(e));
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }
}
