import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';

import '../entity/leave_history_entity.dart';

abstract interface class LeaveHistoryRepository {
  Future<Either<Failure, List<LeaveHistoryEntity>>> getLeaveRequests();
}
