import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/tasks/data/models/task_model.dart';
import 'package:workwise/features/tasks/data/models/task_submission_model.dart';
import 'package:workwise/features/tasks/data/models/tasks_response_model.dart';

abstract class TasksRepository {
  Future<Either<Failure, TasksResponseModel>> getTasks({
    String? lang,
    String? status,
    String? priority,
    String? deadlineFrom,
    String? deadlineTo,
    int? perPage,
    int? page,
  });

  Future<Either<Failure, TaskModel>> updateTaskProgress({
    required int taskId,
    required int progress,
    String? lang,
  });

  Future<Either<Failure, TaskModel>> updateTaskStatus({
    required int taskId,
    required String status,
    String? lang,
  });

  Future<Either<Failure, TaskSubmissionResponseModel>> submitTask({
    required int taskId,
    required String note,
    List<String>? filePaths,
    String? lang,
  });

  Future<Either<Failure, TaskSubmissionResponseModel>> getSubmissionDetails({
    required int submissionId,
    String? lang,
  });

  Future<Either<Failure, SubmissionAttachment>> addSubmissionAttachment({
    required int submissionId,
    required String filePath,
    String? lang,
  });
}
