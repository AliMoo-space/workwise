import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/performance/domain/performance/entities/performance_entity.dart';
import 'package:workwise/features/performance/domain/performance/repositories/performance_repository.dart';

class GetPerformanceUseCase {
  final PerformanceRepository repository;

  GetPerformanceUseCase(this.repository);

  Future<Either<Failure, PerformanceEntity>> call() {
    return repository.getPerformance();
  }
}
