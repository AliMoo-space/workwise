import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/tasks/data/models/task_submission_model.dart';
import 'package:workwise/features/tasks/domain/repositories/tasks_repository.dart';

class SubmitTaskUseCase {
  final TasksRepository repository;

  SubmitTaskUseCase({required this.repository});

  Future<Either<Failure, TaskSubmissionResponseModel>> call({
    required int taskId,
    required String note,
    List<String>? filePaths,
    String? lang,
  }) async {
    return await repository.submitTask(
      taskId: taskId,
      note: note,
      filePaths: filePaths,
      lang: lang,
    );
  }
}
