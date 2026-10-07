import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/tasks/data/models/tasks_response_model.dart';
import 'package:workwise/features/tasks/domain/repositories/tasks_repository.dart';

class GetTasksUseCase {
  final TasksRepository repository;

  GetTasksUseCase({required this.repository});

  Future<Either<Failure, TasksResponseModel>> call({
    String? lang,
    String? status,
    String? priority,
    String? deadlineFrom,
    String? deadlineTo,
    int? perPage,
    int? page,
  }) async {
    return await repository.getTasks(
      lang: lang,
      status: status,
      priority: priority,
      deadlineFrom: deadlineFrom,
      deadlineTo: deadlineTo,
      perPage: perPage,
      page: page,
    );
  }
}
