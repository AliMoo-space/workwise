import 'package:dio/dio.dart';

import 'package:workwise/core/network/api_consumer.dart';
import 'package:workwise/core/network/endpoints/api_endpoints.dart';
import 'package:workwise/core/network/error_message.dart';

import '../models/leave_request_model.dart';

abstract interface class LeaveRemoteDataSource {
  Future<void> createLeaveRequest(LeaveRequestModel request);
}

class LeaveRemoteDataSourceImpl implements LeaveRemoteDataSource {
  final ApiConsumer apiConsumer;

  LeaveRemoteDataSourceImpl(this.apiConsumer);

  @override
  Future<void> createLeaveRequest(LeaveRequestModel request) async {
    try {
      final data = request.toJson();

      await apiConsumer.post(ApiEndpoints.leaveRequests, data: data);
    } on DioException catch (e) {
      throw Exception(ErrorMessage.fromDioException(e));
    }
  }
}
