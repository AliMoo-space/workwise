// leave_history_repository.dart
import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/leave/domain/entity/leave_history.dart';

abstract class LeaveHistoryRepository {
  Future<Either<Failure, List<LeaveHistory>>> getLeaveHistory();
}
