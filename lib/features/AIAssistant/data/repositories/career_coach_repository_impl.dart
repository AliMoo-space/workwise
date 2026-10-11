import 'package:dartz/dartz.dart';

import 'package:workwise/core/errors/failure.dart';

import 'package:workwise/features/AIAssistant/domain/entities/career_coach.dart';
import 'package:workwise/features/AIAssistant/domain/repositories/career_coach_repository.dart';

import '../datasource/career_coach_remote_data_source.dart';

class CareerCoachRepositoryImpl implements CareerCoachRepository {
  const CareerCoachRepositoryImpl({required this.remoteDataSource});

  final CareerCoachRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, CareerCoach>> getCareerCoach(
    Map<String, dynamic> body,
  ) async {
    try {
      final result = await remoteDataSource.getCareerCoach(body);

      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
