import 'package:dio/dio.dart';

import 'package:workwise/core/network/api_consumer.dart';
import 'package:workwise/core/network/endpoints/api_endpoints.dart';

import '../models/leave_balance_model.dart';

abstract interface class LeaveBalanceRemoteDataSource {
  Future<List<LeaveBalanceModel>> getLeaveBalances();
}

class LeaveBalanceRemoteDataSourceImpl implements LeaveBalanceRemoteDataSource {
  const LeaveBalanceRemoteDataSourceImpl(this.apiConsumer);

  final ApiConsumer apiConsumer;

  @override
  Future<List<LeaveBalanceModel>> getLeaveBalances() async {
    try {
      final response = await apiConsumer.get(ApiEndpoints.leaveBalances);

      final responseData = response.data;

      if (responseData is! Map<String, dynamic>) {
        throw const FormatException('Invalid leave balances response format');
      }

      final data = responseData['data'];

      if (data is! List) {
        throw const FormatException('Invalid leave balances data format');
      }

      return data
          .map(
            (leave) =>
                LeaveBalanceModel.fromJson(leave as Map<String, dynamic>),
          )
          .toList();
    } on DioException catch (e) {
      final responseData = e.response?.data;

      if (responseData is Map<String, dynamic>) {
        final message = responseData['message'];

        if (message is String && message.isNotEmpty) {
          throw Exception(message);
        }
      }

      throw Exception(e.message ?? 'Something went wrong');
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }
}
