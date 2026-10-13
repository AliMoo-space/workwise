import 'package:workwise/core/network/api_consumer.dart';
import 'package:workwise/features/tasks/data/models/task_model.dart';
import 'package:workwise/features/tasks/data/models/task_submission_model.dart';
import 'package:workwise/features/tasks/data/models/tasks_response_model.dart';

abstract class TasksRemoteDataSource {
  Future<TasksResponseModel> getTasks({
    String? lang,
    String? status,
    String? priority,
    String? deadlineFrom,
    String? deadlineTo,
    int? perPage,
    int? page,
  });

  Future<TaskModel> updateTaskProgress({
    required int taskId,
    required int progress,
    String? lang,
  });

  Future<TaskModel> updateTaskStatus({
    required int taskId,
    required String status,
    String? lang,
  });

  Future<TaskSubmissionResponseModel> submitTask({
    required int taskId,
    required String note,
    List<String>? filePaths,
    String? lang,
  });

  Future<TaskSubmissionResponseModel> getSubmissionDetails({
    required int submissionId,
    String? lang,
  });

  Future<SubmissionAttachment> addSubmissionAttachment({
    required int submissionId,
    required String filePath,
    String? lang,
  });

  Future<TaskSubmissionResponseModel> resubmitSubmission({
    required int submissionId,
    required String note,
    String? lang,
  });
}

abstract class TasksRemoteDataSourceBase implements TasksRemoteDataSource {
  final ApiConsumer apiConsumer;

  TasksRemoteDataSourceBase({required this.apiConsumer});
}
