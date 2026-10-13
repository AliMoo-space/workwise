part of '../tasks_cubit.dart';

extension TasksCubitGetSubmissionDetails on TasksCubit {
  Future<TaskSubmissionResponseModel?> getSubmissionDetails({
    required int submissionId,
  }) async {
    final result = await getSubmissionDetailsUseCase(
      submissionId: submissionId,
      lang: _currentLang,
    );

    return result.fold((failure) => null, (response) => response);
  }
}
