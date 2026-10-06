import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';

import '../entities/goal_details_entity.dart';
import '../repositories/goal_details_repository.dart';

class GetGoalDetails {
  const GetGoalDetails(this.repository);

  final GoalDetailsRepository repository;

  Future<Either<Failure, GoalDetailsEntity>> call(int goalId) {
    return repository.getGoalDetails(goalId);
  }
}
