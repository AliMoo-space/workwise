import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';
import 'package:workwise/core/design_system/widgets/buttons/app_button.dart';
import 'package:workwise/core/design_system/widgets/buttons/app_icon_button.dart';
import 'package:workwise/core/design_system/widgets/feedback/app_snack_bar.dart';
import 'package:workwise/core/design_system/widgets/inputs/app_text_field.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';
import 'package:workwise/features/tasks/presentation/cubit/tasks_cubit.dart';
import '../../domain/models/task_models.dart';
import '../widgets/attachment_uploader.dart';
import '../widgets/custom_widgets/priority_badge.dart';
import '../widgets/progress_slider.dart';
import '../widgets/task_status_badge.dart';

class TaskSubmissionScreen extends StatelessWidget {
  TaskSubmissionScreen({super.key, required this.task, this.onSubmitted})
    : _notesController = TextEditingController(),
      _draftProgress = ValueNotifier(task.progress),
      _attachments = ValueNotifier<List<TaskAttachment>>([]),
      _isSubmitting = ValueNotifier(false);

  final Task task;
  final VoidCallback? onSubmitted;
  final TextEditingController _notesController;
  final ValueNotifier<int> _draftProgress;
  final ValueNotifier<List<TaskAttachment>> _attachments;
  final ValueNotifier<bool> _isSubmitting;

  void _updateProgress(double value) {
    _draftProgress.value = value.round();
  }

  void _pickAttachment(List<TaskAttachment> newAttachments) {
    final current = _attachments.value;
    _attachments.value = [...current, ...newAttachments];
  }

  void _removeAttachment(TaskAttachment attachment) {
    final current = _attachments.value;
    _attachments.value = current.where((item) => item != attachment).toList();
  }

  Future<void> _submitForReview(BuildContext context) async {
    _isSubmitting.value = true;

    final taskId = int.tryParse(task.id);
    if (taskId == null) {
      _isSubmitting.value = false;
      if (context.mounted) {
        AppSnackBar.error(context, message: context.l10n.invalidTaskId);
      }
      return;
    }

    // التحقق من الملاحظة
    if (_notesController.text.trim().isEmpty) {
      _isSubmitting.value = false;
      if (context.mounted) {
        AppSnackBar.error(context, message: context.l10n.addNoteBeforeSubmit);
      }
      return;
    }

    // جمع file paths من الـ attachments
    final filePaths = _attachments.value
        .where((attachment) => attachment.localPath != null && attachment.localPath!.isNotEmpty)
        .map((attachment) => attachment.localPath!)
        .toList();

    // إظهار رسالة أثناء الرفع
    if (context.mounted && filePaths.isNotEmpty) {
      AppSnackBar.info(context, message: context.l10n.uploadingFiles);
    }

    // تحديث نسبة الإنجاز إذا تم تغييرها
    if (_draftProgress.value != task.progress) {
      await context.read<TasksCubit>().updateTaskProgress(
        taskId: taskId,
        progress: _draftProgress.value,
      );
    }

    if (!context.mounted) return;

    // استدعاء الـ API
    final (success, errorMessage) = await context.read<TasksCubit>().submitTask(
      taskId: taskId,
      note: _notesController.text.trim(),
      filePaths: filePaths.isNotEmpty ? filePaths : null,
    );

    _isSubmitting.value = false;

    if (context.mounted) {
      if (success) {
        AppSnackBar.success(context, message: context.l10n.taskSubmittedSuccess);
        Navigator.of(context).pop();
        onSubmitted?.call();
      } else {
        AppSnackBar.error(
          context,
          message: errorMessage ?? context.l10n.taskSubmitFailed,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _draftProgress,
      builder: (context, draftProgress, _) {
        return ValueListenableBuilder<List<TaskAttachment>>(
          valueListenable: _attachments,
          builder: (context, attachments, _) {
            return ValueListenableBuilder<bool>(
              valueListenable: _isSubmitting,
              builder: (context, isSubmitting, _) {
                return Scaffold(
                  backgroundColor: AppColors.onPrimary,
                  body: SafeArea(
                    top: false,
                    child: Column(
                      children: [
                        Center(
                          child: Container(
                            width: 36.w,
                            height: 4.h,
                            margin: EdgeInsets.only(top: 10.h, bottom: 8.h),
                            decoration: BoxDecoration(
                              color: AppColors.textDisabled,
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 4.h,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      'T-${task.id}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Colors.grey.shade600,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                    Gap(2.h),
                                    AppText(
                                      task.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18.sp,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Gap(12.h),
                              AppIconButton(
                                icon: Icons.close,
                                size: 36.r,
                                iconSize: 18.r,
                                variant: AppIconButtonVariant.ghost,
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          child: Row(
                            children: [
                              PriorityBadge(priority: task.priority),
                              const Gap(8),
                              TaskStatusBadge(status: task.status),
                              const Gap(12),
                              AppText(
                                '${context.l10n.due} ${_date(task.deadline)}',
                                style: TextStyle(
                                  color: AppColors.textHint,
                                  fontSize: 13.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.all(16.r),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (task.feedback != null) ...[Gap(16.h)],
                                Gap(28.h),
                                ProgressSlider(
                                  value: draftProgress,
                                  enabled: !isSubmitting,
                                  onChanged: _updateProgress,
                                ),
                                Gap(24.h),
                                AppTextField(
                                  label: context.l10n.notes,
                                  controller: _notesController,
                                  enabled: !isSubmitting,
                                  type: AppTextFieldType.multiline,
                                  minLines: 3,
                                  maxLines: 5,
                                  hintText: context.l10n.notesHint,
                                ),
                                Gap(24.h),
                                AttachmentUploader(
                                  attachments: attachments,
                                  onPick: _pickAttachment,
                                  onRemove: _removeAttachment,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(30.r),
                          child: AppButton(
                            text: context.l10n.submitForReview,
                            onPressed: () => _submitForReview(context),
                            isLoading: isSubmitting,
                            enabled: !isSubmitting,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  static String _date(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }
}
