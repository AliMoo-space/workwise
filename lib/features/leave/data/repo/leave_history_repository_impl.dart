import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/leave/data/datasourse/leave_history_remote_data_source.dart';
import 'package:workwise/features/leave/domain/entity/leave_history_entity.dart';
import 'package:workwise/features/leave/domain/repo/leave_history_repository.dart';

class LeaveHistoryRepositoryImpl implements LeaveHistoryRepository {
  final LeaveHistoryRemoteDataSource remoteDataSource;

  LeaveHistoryRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<LeaveHistoryEntity>>> getLeaveRequests() async {
    try {
      final result = await remoteDataSource.getLeaveRequests();

      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
