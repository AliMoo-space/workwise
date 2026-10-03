import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/leave/domain/entity/leave_history_entity.dart';
import 'package:workwise/features/leave/domain/repo/leave_history_repository.dart';

class GetLeaveHistoryUseCase {
  const GetLeaveHistoryUseCase(this.repository);

  final LeaveHistoryRepository repository;

  Future<Either<Failure, List<LeaveHistoryEntity>>> call() {
    return repository.getLeaveHistory();
  }
}
