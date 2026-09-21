// leave_history_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/leave/data/datasourse/leave_history_remote_data_source.dart';
import 'package:workwise/features/leave/domain/entity/leave_history.dart';
import 'package:workwise/features/leave/domain/repo/leave_history_repository.dart';

class LeaveHistoryRepositoryImpl implements LeaveHistoryRepository {
  final LeaveHistoryRemoteDataSource remoteDataSource;

  LeaveHistoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<LeaveHistory>>> getLeaveHistory() async {
    try {
      final result = await remoteDataSource.getLeaveHistory();

      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
