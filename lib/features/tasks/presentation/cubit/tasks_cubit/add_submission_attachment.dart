part of '../tasks_cubit.dart';

extension TasksCubitAddSubmissionAttachment on TasksCubit {
  Future<SubmissionAttachment?> addSubmissionAttachment({
    required int submissionId,
    required String filePath,
  }) async {
    final result = await addSubmissionAttachmentUseCase(
      submissionId: submissionId,
      filePath: filePath,
      lang: _currentLang,
    );

    return result.fold((failure) => null, (attachment) => attachment);
  }
}
