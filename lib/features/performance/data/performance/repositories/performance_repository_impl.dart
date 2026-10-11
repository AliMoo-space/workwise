import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/performance/data/performance/datasources/performance_remote_data_source.dart';
import 'package:workwise/features/performance/domain/performance/entities/performance_entity.dart';
import 'package:workwise/features/performance/domain/performance/repositories/performance_repository.dart';

class PerformanceRepositoryImpl implements PerformanceRepository {
  final PerformanceRemoteDataSource remoteDataSource;

  PerformanceRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, PerformanceEntity>> getPerformance() async {
    try {
      final result = await remoteDataSource.getPerformance();

      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
