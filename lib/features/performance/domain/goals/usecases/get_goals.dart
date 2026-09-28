import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';
import '../entities/goal.dart';
import '../repositories/goals_repository.dart';

class GetGoals {
  final GoalsRepository repository;

  const GetGoals(this.repository);

  Future<Either<Failure, List<Goal>>> call() {
    return repository.getGoals();
  }
}
