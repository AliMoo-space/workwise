import 'package:dartz/dartz.dart';

import 'package:workwise/core/errors/failure.dart';

import '../entities/career_coach.dart';

abstract interface class CareerCoachRepository {
  Future<Either<Failure, CareerCoach>> getCareerCoach(
    Map<String, dynamic> body,
  );
}
