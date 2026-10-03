import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/leave/data/datasourse/leave_balance_remote_data_source.dart';
import 'package:workwise/features/leave/domain/entity/leave_balance_entity.dart';
import 'package:workwise/features/leave/domain/repo/leave_balance_repository.dart';

class LeaveBalanceRepositoryImpl implements LeaveBalanceRepository {
  const LeaveBalanceRepositoryImpl(this.remoteDataSource);

  final LeaveBalanceRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, List<LeaveBalanceEntity>>> getLeaveBalances() async {
    try {
      final balances = await remoteDataSource.getLeaveBalances();

      return Right(balances);
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
