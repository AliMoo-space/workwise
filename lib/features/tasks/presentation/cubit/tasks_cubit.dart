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

  Future<void> getTasks({
    String? lang,
    String? status,
    String? priority,
    String? deadlineFrom,
    String? deadlineTo,
    int? perPage,
    bool refresh = false,
  }) async {
    if (refresh) {
      _currentPage = 1;
      emit(TasksLoading());
    } else if (state is TasksLoaded) {
      final currentState = state as TasksLoaded;
      if (currentState.response.data.currentPage >= 
          currentState.response.data.lastPage) {
        return; // No more pages to load
      }
      _currentPage++;
      emit(currentState.copyWith(isLoadingMore: true));
    } else {
      emit(TasksLoading());
    }

    // Store current filters
    _currentLang = lang ?? _currentLang;
    _currentStatus = status ?? _currentStatus;
    _currentPriority = priority ?? _currentPriority;
    _currentDeadlineFrom = deadlineFrom ?? _currentDeadlineFrom;
    _currentDeadlineTo = deadlineTo ?? _currentDeadlineTo;
    _perPage = perPage ?? _perPage;

    final result = await getTasksUseCase(
      lang: _currentLang,
      status: _currentStatus,
      priority: _currentPriority,
      deadlineFrom: _currentDeadlineFrom,
      deadlineTo: _currentDeadlineTo,
      perPage: _perPage,
      page: _currentPage,
    );

    result.fold(
      (failure) => emit(TasksError(message: failure.message)),
      (response) {
        if (state is TasksLoaded && !refresh) {
          final currentState = state as TasksLoaded;
          final updatedTasks = [
            ...currentState.response.data.tasks,
            ...response.data.tasks,
          ];
          
          final updatedResponse = TasksResponseModel(
            success: response.success,
            message: response.message,
            data: PaginationData(
              currentPage: response.data.currentPage,
              tasks: updatedTasks,
              firstPageUrl: response.data.firstPageUrl,
              from: response.data.from,
              lastPage: response.data.lastPage,
              lastPageUrl: response.data.lastPageUrl,
              links: response.data.links,
              nextPageUrl: response.data.nextPageUrl,
              path: response.data.path,
              perPage: response.data.perPage,
              prevPageUrl: response.data.prevPageUrl,
              to: response.data.to,
              total: response.data.total,
            ),
          );
          emit(TasksLoaded(response: updatedResponse));
        } else {
          emit(TasksLoaded(response: response));
        }
      },
    );
  }

  void applyFilters({
    String? lang,
    String? status,
    String? priority,
    String? deadlineFrom,
    String? deadlineTo,
  }) {
    getTasks(
      lang: lang,
      status: status,
      priority: priority,
      deadlineFrom: deadlineFrom,
      deadlineTo: deadlineTo,
      refresh: true,
    );
  }

  void loadMore() {
    if (state is TasksLoaded) {
      getTasks();
    }
  }

  void refresh() {
    getTasks(refresh: true);
  }

  Future<void> updateTaskProgress({
    required int taskId,
    required int progress,
  }) async {
    final result = await updateTaskProgressUseCase(
      taskId: taskId,
      progress: progress,
      lang: _currentLang,
    );

    result.fold(
      (failure) {
        // يمكن إضافة emit للـ error لو عايز تظهر message
        // emit(TasksError(message: failure.message));
      },
      (updatedTask) {
        // تحديث الـ task في الـ list
        if (state is TasksLoaded) {
          final currentState = state as TasksLoaded;
          final updatedTasks = currentState.response.data.tasks.map((task) {
            if (task.id == taskId) {
              return updatedTask;
            }
            return task;
          }).toList();

          final updatedResponse = TasksResponseModel(
            success: currentState.response.success,
            message: currentState.response.message,
            data: PaginationData(
              currentPage: currentState.response.data.currentPage,
              tasks: updatedTasks,
              firstPageUrl: currentState.response.data.firstPageUrl,
              from: currentState.response.data.from,
              lastPage: currentState.response.data.lastPage,
              lastPageUrl: currentState.response.data.lastPageUrl,
              links: currentState.response.data.links,
              nextPageUrl: currentState.response.data.nextPageUrl,
              path: currentState.response.data.path,
              perPage: currentState.response.data.perPage,
              prevPageUrl: currentState.response.data.prevPageUrl,
              to: currentState.response.data.to,
              total: currentState.response.data.total,
            ),
          );

          emit(TasksLoaded(response: updatedResponse));
        }
      },
    );
  }

  Future<void> updateTaskStatus({
    required int taskId,
    required String status,
  }) async {
    final result = await updateTaskStatusUseCase(
      taskId: taskId,
      status: status,
      lang: _currentLang,
    );

    result.fold(
      (failure) {
        // يمكن إضافة emit للـ error message
      },
      (updatedTask) {
        // تحديث الـ task في الـ list
        if (state is TasksLoaded) {
          final currentState = state as TasksLoaded;
          final updatedTasks = currentState.response.data.tasks.map((task) {
            if (task.id == taskId) {
              return updatedTask;
            }
            return task;
          }).toList();

          final updatedResponse = TasksResponseModel(
            success: currentState.response.success,
            message: currentState.response.message,
            data: PaginationData(
              currentPage: currentState.response.data.currentPage,
              tasks: updatedTasks,
              firstPageUrl: currentState.response.data.firstPageUrl,
              from: currentState.response.data.from,
              lastPage: currentState.response.data.lastPage,
              lastPageUrl: currentState.response.data.lastPageUrl,
              links: currentState.response.data.links,
              nextPageUrl: currentState.response.data.nextPageUrl,
              path: currentState.response.data.path,
              perPage: currentState.response.data.perPage,
              prevPageUrl: currentState.response.data.prevPageUrl,
              to: currentState.response.data.to,
              total: currentState.response.data.total,
            ),
          );

          emit(TasksLoaded(response: updatedResponse));
        }
      },
    );
  }

  Future<(bool success, String? message)> submitTask({
    required int taskId,
    required String note,
    List<String>? filePaths,
  }) async {
    final result = await submitTaskUseCase(
      taskId: taskId,
      note: note,
      filePaths: filePaths,
      lang: _currentLang,
    );

    return result.fold(
      (failure) {
        return (false, failure.message);
      },
      (response) {
        refresh();
        return (true, null);
      },
    );
  }

  Future<TaskSubmissionResponseModel?> getSubmissionDetails({
    required int submissionId,
  }) async {
    final result = await getSubmissionDetailsUseCase(
      submissionId: submissionId,
      lang: _currentLang,
    );

    return result.fold(
      (failure) {
        // Error occurred
        return null;
      },
      (response) {
        // Success
        return response;
      },
    );
  }

  Future<SubmissionAttachment?> addSubmissionAttachment({
    required int submissionId,
    required String filePath,
  }) async {
    final result = await addSubmissionAttachmentUseCase(
      submissionId: submissionId,
      filePath: filePath,
      lang: _currentLang,
    );

    return result.fold(
      (failure) {
        // Error occurred
        return null;
      },
      (attachment) {
        // Success
        return attachment;
      },
    );
  }
}
