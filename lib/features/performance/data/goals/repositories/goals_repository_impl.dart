import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/performance/domain/goals/entities/goal.dart';
import 'package:workwise/features/performance/domain/goals/repositories/goals_repository.dart';

import '../datasources/goals_remote_data_source.dart';

class GoalsRepositoryImpl implements GoalsRepository {
  final GoalsRemoteDataSource remoteDataSource;

  GoalsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Goal>>> getGoals() async {
    try {
      final result = await remoteDataSource.getGoals();

      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
