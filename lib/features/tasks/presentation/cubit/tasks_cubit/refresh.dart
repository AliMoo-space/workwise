part of '../tasks_cubit.dart';

extension TasksCubitRefresh on TasksCubit {
  void refresh() {
    getTasks(refresh: true);
  }
}
