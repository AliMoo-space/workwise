import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/tasks/data/models/task_submission_model.dart';
import 'package:workwise/features/tasks/domain/repositories/tasks_repository.dart';

class GetSubmissionDetailsUseCase {
  final TasksRepository repository;

  GetSubmissionDetailsUseCase({required this.repository});

  Future<Either<Failure, TaskSubmissionResponseModel>> call({
    required int submissionId,
    String? lang,
  }) async {
    return await repository.getSubmissionDetails(
      submissionId: submissionId,
      lang: lang,
    );
  }
}
