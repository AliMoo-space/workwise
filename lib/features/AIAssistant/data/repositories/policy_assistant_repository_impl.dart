import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/AIAssistant/domain/entities/policy_assistant_entity.dart';
import 'package:workwise/features/AIAssistant/domain/repositories/policy_assistant_repository.dart';

import '../datasource/policy_assistant_remote_data_source.dart';

class PolicyAssistantRepositoryImpl implements PolicyAssistantRepository {
  const PolicyAssistantRepositoryImpl({required this.remoteDataSource});

  final PolicyAssistantRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, PolicyAssistantEntity>> askPolicyQuestion(
    Map<String, dynamic> body,
  ) async {
    try {
      final result = await remoteDataSource.askPolicyQuestion(body);

      return Right(result);
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');

      return Left(ServerFailure(message));
    }
  }
}
