import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/leave/domain/entity/leave_balance_entity.dart';

abstract interface class LeaveBalanceRepository {
  Future<Either<Failure, List<LeaveBalanceEntity>>> getLeaveBalances();
}
