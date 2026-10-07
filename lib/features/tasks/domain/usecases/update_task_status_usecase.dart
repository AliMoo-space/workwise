import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/tasks/data/models/task_model.dart';
import 'package:workwise/features/tasks/domain/repositories/tasks_repository.dart';

class UpdateTaskStatusUseCase {
  final TasksRepository repository;

  UpdateTaskStatusUseCase({required this.repository});

  Future<Either<Failure, TaskModel>> call({
    required int taskId,
    required String status,
    String? lang,
  }) async {
    return await repository.updateTaskStatus(
      taskId: taskId,
      status: status,
      lang: lang,
    );
  }
}
