// get_leave_history.dart
import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/leave/domain/entity/leave_history.dart';
import 'package:workwise/features/leave/domain/repo/leave_history_repository.dart';

class GetLeaveHistory {
  final LeaveHistoryRepository repository;

  GetLeaveHistory(this.repository);

  Future<Either<Failure, List<LeaveHistory>>> call() {
    return repository.getLeaveHistory();
  }
}
