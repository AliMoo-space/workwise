import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/leave/domain/entity/leave_balance.dart';
import 'package:workwise/features/leave/domain/repo/leave_repository.dart';

class GetLeaveBalances {
  final LeaveRepository repository;

  const GetLeaveBalances(this.repository);

  Future<Either<Failure, List<LeaveBalance>>> call() {
    return repository.getLeaveBalances();
  }
}
