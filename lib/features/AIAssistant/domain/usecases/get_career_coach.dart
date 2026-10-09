import 'package:dartz/dartz.dart';

import 'package:workwise/core/errors/failure.dart';

import '../entities/career_coach.dart';
import '../repositories/career_coach_repository.dart';

final class GetCareerCoach {
  const GetCareerCoach(this.repository);

  final CareerCoachRepository repository;

  Future<Either<Failure, CareerCoach>> call(Map<String, dynamic> body) {
    return repository.getCareerCoach(body);
  }
}
