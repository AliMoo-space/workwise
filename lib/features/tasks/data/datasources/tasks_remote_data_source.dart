import 'package:workwise/features/tasks/data/datasources/tasks_remote_data_source/add_submission_attachment.dart';
import 'package:workwise/features/tasks/data/datasources/tasks_remote_data_source/get_submission_details.dart';
import 'package:workwise/features/tasks/data/datasources/tasks_remote_data_source/get_tasks.dart';
import 'package:workwise/features/tasks/data/datasources/tasks_remote_data_source/resubmit_submission.dart';
import 'package:workwise/features/tasks/data/datasources/tasks_remote_data_source/submit_task.dart';
import 'package:workwise/features/tasks/data/datasources/tasks_remote_data_source/update_task_progress.dart';
import 'package:workwise/features/tasks/data/datasources/tasks_remote_data_source/update_task_status.dart';
import 'package:workwise/features/tasks/data/datasources/tasks_remote_data_source_contract.dart';

export 'package:workwise/features/tasks/data/datasources/tasks_remote_data_source_contract.dart'
    show TasksRemoteDataSource;

class TasksRemoteDataSourceImpl extends TasksRemoteDataSourceBase
    with
        GetTasks,
        UpdateTaskProgress,
        UpdateTaskStatus,
        SubmitTask,
        GetSubmissionDetails,
        AddSubmissionAttachment,
        ResubmitSubmission {
  TasksRemoteDataSourceImpl({required super.apiConsumer});
}
