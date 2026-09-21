import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/leave/domain/entity/leave_balance.dart';

abstract class LeaveRepository {
  Future<Either<Failure, List<LeaveBalance>>> getLeaveBalances();
}
