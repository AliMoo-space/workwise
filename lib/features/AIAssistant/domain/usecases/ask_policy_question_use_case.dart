import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/AIAssistant/domain/entities/policy_assistant_entity.dart';
import 'package:workwise/features/AIAssistant/domain/repositories/policy_assistant_repository.dart';

class AskPolicyQuestionUseCase {
  const AskPolicyQuestionUseCase(this.repository);

  final PolicyAssistantRepository repository;

  Future<Either<Failure, PolicyAssistantEntity>> call(
    Map<String, dynamic> body,
  ) {
    return repository.askPolicyQuestion(body);
  }
}
