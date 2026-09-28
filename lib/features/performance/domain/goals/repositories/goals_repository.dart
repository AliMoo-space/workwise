import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';
import '../entities/goal.dart';

abstract class GoalsRepository {
  Future<Either<Failure, List<Goal>>> getGoals();
}
