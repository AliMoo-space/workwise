import 'package:workwise/features/leave/data/models/leave_history_model.dart';

abstract class LeaveHistoryRemoteDataSource {
  Future<List<LeaveHistoryModel>> getLeaveHistory();
}

class LeaveHistoryRemoteDataSourceImpl implements LeaveHistoryRemoteDataSource {
  @override
  Future<List<LeaveHistoryModel>> getLeaveHistory() async {
    await Future.delayed(const Duration(seconds: 2));

    return const [
      LeaveHistoryModel(
        type: 'Annual',
        startDate: 'May 20',
        endDate: 'May 24',
        days: 5,
        status: 'approved',
      ),
      LeaveHistoryModel(
        type: 'Casual',
        startDate: 'June 10',
        endDate: 'June 11',
        days: 2,
        status: 'pending',
      ),
      LeaveHistoryModel(
        type: 'Sick',
        startDate: 'July 05',
        endDate: 'July 06',
        days: 2,
        status: 'rejected',
      ),
    ];
  }
}
