import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/leave/data/datasourse/leave_remote_data_source.dart';
import 'package:workwise/features/leave/domain/entity/leave_balance.dart';
import 'package:workwise/features/leave/domain/repo/leave_repository.dart';

class LeaveRepositoryImpl implements LeaveRepository {
  final LeaveRemoteDataSource remoteDataSource;

  LeaveRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<LeaveBalance>>> getLeaveBalances() async {
    try {
      final balances = await remoteDataSource.getLeaveBalances();

      return Right(balances);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
