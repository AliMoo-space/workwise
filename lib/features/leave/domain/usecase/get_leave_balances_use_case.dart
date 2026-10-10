import 'package:dartz/dartz.dart';

import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/leave/domain/entity/leave_balance_entity.dart';
import 'package:workwise/features/leave/domain/repo/leave_balance_repository.dart';

class GetLeaveBalancesUseCase {
  final LeaveBalanceRepository repository;

  GetLeaveBalancesUseCase(this.repository);

  Future<Either<Failure, List<LeaveBalanceEntity>>> call() {
    return repository.getLeaveBalances();
  }
}
