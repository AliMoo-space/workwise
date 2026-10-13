import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';

import '../entities/policy_assistant_entity.dart';

abstract interface class PolicyAssistantRepository {
  Future<Either<Failure, PolicyAssistantEntity>> askPolicyQuestion(
    Map<String, dynamic> body,
  );
}
