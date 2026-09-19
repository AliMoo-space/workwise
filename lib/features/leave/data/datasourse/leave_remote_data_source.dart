import 'package:workwise/features/leave/data/models/leave_balance_model.dart';

abstract class LeaveRemoteDataSource {
  Future<List<LeaveBalanceModel>> getLeaveBalances();
}

class LeaveRemoteDataSourceImpl implements LeaveRemoteDataSource {
  @override
  Future<List<LeaveBalanceModel>> getLeaveBalances() async {
    await Future.delayed(const Duration(seconds: 2));

    return [
      LeaveBalanceModel(type: 'Annual', usedDays: 8, totalDays: 21),
      LeaveBalanceModel(type: 'Casual', usedDays: 3, totalDays: 7),
      LeaveBalanceModel(type: 'Sick', usedDays: 2, totalDays: 10),
    ];
  }
}
