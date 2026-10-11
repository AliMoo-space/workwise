import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/tasks/data/models/task_submission_model.dart';
import 'package:workwise/features/tasks/domain/repositories/tasks_repository.dart';

class AddSubmissionAttachmentUseCase {
  final TasksRepository repository;

  AddSubmissionAttachmentUseCase({required this.repository});

  Future<Either<Failure, SubmissionAttachment>> call({
    required int submissionId,
    required String filePath,
    String? lang,
  }) async {
    return await repository.addSubmissionAttachment(
      submissionId: submissionId,
      filePath: filePath,
      lang: lang,
    );
  }
}