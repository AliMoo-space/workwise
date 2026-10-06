import 'package:dio/dio.dart';

import 'package:workwise/core/network/api_consumer.dart';
import 'package:workwise/core/network/endpoints/api_endpoints.dart';
import 'package:workwise/core/network/error_message.dart';

import '../models/leave_balance_model.dart';

abstract interface class LeaveBalanceRemoteDataSource {
  Future<List<LeaveBalanceModel>> getLeaveBalances();
}

class LeaveBalanceRemoteDataSourceImpl implements LeaveBalanceRemoteDataSource {
  final ApiConsumer apiConsumer;

  LeaveBalanceRemoteDataSourceImpl(this.apiConsumer);

  @override
  Future<List<LeaveBalanceModel>> getLeaveBalances() async {
    try {
      final response = await apiConsumer.get(ApiEndpoints.leaveBalances);

      final List<dynamic> data = response.data['data'] as List<dynamic>;

      return data
          .map(
            (json) => LeaveBalanceModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } on DioException catch (e) {
      throw Exception(ErrorMessage.fromDioException(e));
    }
  }
}
