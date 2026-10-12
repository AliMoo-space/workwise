part of '../tasks_cubit.dart';

extension TasksCubitGetTasks on TasksCubit {
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
      _emitState(TasksLoading());
    } else if (state is TasksLoaded) {
      final currentState = state as TasksLoaded;
      if (currentState.response.data.currentPage >=
          currentState.response.data.lastPage) {
        return;
      }
      _currentPage++;
      _emitState(currentState.copyWith(isLoadingMore: true));
    } else {
      _emitState(TasksLoading());
    }

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

    result.fold((failure) => _emitState(TasksError(message: failure.message)), (
      response,
    ) {
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
        _emitState(TasksLoaded(response: updatedResponse));
      } else {
        _emitState(TasksLoaded(response: response));
      }
    });
  }
}
