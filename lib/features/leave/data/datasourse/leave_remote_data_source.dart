import 'package:workwise/core/network/dio_consumer.dart';
import 'package:workwise/core/network/endpoints/api_endpoints.dart';
import '../models/leave_request_model.dart';

abstract class LeaveRemoteDataSource {
  Future<void> createLeaveRequest(LeaveRequestModel request);
}

class LeaveRemoteDataSourceImpl implements LeaveRemoteDataSource {
  final DioConsumer dioConsumer;

  LeaveRemoteDataSourceImpl(this.dioConsumer);

  @override
  Future<void> createLeaveRequest(LeaveRequestModel request) async {
    await dioConsumer.post(ApiEndpoints.leaveRequests, data: request.toJson());
  }
}
