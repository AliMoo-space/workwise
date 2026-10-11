import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/performance/domain/performance/entities/performance_entity.dart';

abstract class PerformanceRepository {
  Future<Either<Failure, PerformanceEntity>> getPerformance();
}
