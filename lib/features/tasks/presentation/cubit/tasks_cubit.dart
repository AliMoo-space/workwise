import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workwise/features/tasks/data/models/task_submission_model.dart';
import 'package:workwise/features/tasks/data/models/tasks_response_model.dart';
import 'package:workwise/features/tasks/domain/usecases/add_submission_attachment_usecase.dart';
import 'package:workwise/features/tasks/domain/usecases/get_submission_details_usecase.dart';
import 'package:workwise/features/tasks/domain/usecases/get_tasks_usecase.dart';
import 'package:workwise/features/tasks/domain/usecases/submit_task_usecase.dart';
import 'package:workwise/features/tasks/domain/usecases/update_task_progress_usecase.dart';
import 'package:workwise/features/tasks/domain/usecases/update_task_status_usecase.dart';
import 'package:workwise/features/tasks/presentation/cubit/tasks_state.dart';

part 'tasks_cubit/add_submission_attachment.dart';
part 'tasks_cubit/apply_filters.dart';
part 'tasks_cubit/get_submission_details.dart';
part 'tasks_cubit/get_tasks.dart';
part 'tasks_cubit/load_more.dart';
part 'tasks_cubit/refresh.dart';
part 'tasks_cubit/submit_task.dart';
part 'tasks_cubit/update_task_progress.dart';
part 'tasks_cubit/update_task_status.dart';

class TasksCubit extends Cubit<TasksState> {
  final GetTasksUseCase getTasksUseCase;
  final UpdateTaskProgressUseCase updateTaskProgressUseCase;
  final UpdateTaskStatusUseCase updateTaskStatusUseCase;
  final SubmitTaskUseCase submitTaskUseCase;
  final GetSubmissionDetailsUseCase getSubmissionDetailsUseCase;
  final AddSubmissionAttachmentUseCase addSubmissionAttachmentUseCase;

  TasksCubit({
    required this.getTasksUseCase,
    required this.updateTaskProgressUseCase,
    required this.updateTaskStatusUseCase,
    required this.submitTaskUseCase,
    required this.getSubmissionDetailsUseCase,
    required this.addSubmissionAttachmentUseCase,
  }) : super(TasksInitial());

  String? _currentLang;
  String? _currentStatus;
  String? _currentPriority;
  String? _currentDeadlineFrom;
  String? _currentDeadlineTo;
  int _currentPage = 1;
  int _perPage = 15;
  void _emitState(TasksState state) {
    emit(state);
  }
}
