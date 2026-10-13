part of '../tasks_cubit.dart';

extension TasksCubitApplyFilters on TasksCubit {
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
}
