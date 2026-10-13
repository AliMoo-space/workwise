part of '../tasks_cubit.dart';

extension TasksCubitSubmitTask on TasksCubit {
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

    return result.fold((failure) => (false, failure.message), (response) {
      refresh();
      return (true, null);
    });
  }
}
