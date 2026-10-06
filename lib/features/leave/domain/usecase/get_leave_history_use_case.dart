import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/leave/domain/repo/leave_history_repository.dart';

import '../entity/leave_history_entity.dart';

final class GetLeaveHistoryUseCase {
  final LeaveHistoryRepository repository;

  const GetLeaveHistoryUseCase(this.repository);

  Future<Either<Failure, List<LeaveHistoryEntity>>> call() {
    return repository.getLeaveRequests();
  }
}
