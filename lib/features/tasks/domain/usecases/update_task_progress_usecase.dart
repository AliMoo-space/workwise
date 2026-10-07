import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/tasks/data/models/task_model.dart';
import 'package:workwise/features/tasks/domain/repositories/tasks_repository.dart';

class UpdateTaskProgressUseCase {
  final TasksRepository repository;

  UpdateTaskProgressUseCase({required this.repository});

  Future<Either<Failure, TaskModel>> call({
    required int taskId,
    required int progress,
    String? lang,
  }) async {
    return await repository.updateTaskProgress(
      taskId: taskId,
      progress: progress,
      lang: lang,
    );
  }
}
