part of '../tasks_cubit.dart';

extension TasksCubitLoadMore on TasksCubit {
  void loadMore() {
    if (state is TasksLoaded) {
      getTasks();
    }
  }
}
