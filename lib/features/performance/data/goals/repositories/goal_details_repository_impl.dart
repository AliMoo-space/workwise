import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/performance/domain/goals/entities/goal_details_entity.dart';
import 'package:workwise/features/performance/domain/goals/repositories/goal_details_repository.dart';
import '../datasources/goal_details_remote_data_source.dart';

class GoalDetailsRepositoryImpl implements GoalDetailsRepository {
  const GoalDetailsRepositoryImpl(this.remoteDataSource);

  final GoalDetailsRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, GoalDetailsEntity>> getGoalDetails(int goalId) async {
    try {
      final result = await remoteDataSource.getGoalDetails(goalId);

      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
