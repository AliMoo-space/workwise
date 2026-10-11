import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';

import '../entities/goal_details_entity.dart';

abstract interface class GoalDetailsRepository {
  Future<Either<Failure, GoalDetailsEntity>> getGoalDetails(int goalId);
}
