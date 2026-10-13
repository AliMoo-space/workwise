part of '../tasks_cubit.dart';

extension TasksCubitUpdateTaskProgress on TasksCubit {
  Future<void> updateTaskProgress({
    required int taskId,
    required int progress,
  }) async {
    final result = await updateTaskProgressUseCase(
      taskId: taskId,
      progress: progress,
      lang: _currentLang,
    );

    result.fold((failure) {}, (updatedTask) {
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

        _emitState(TasksLoaded(response: updatedResponse));
      }
    });
  }
}
