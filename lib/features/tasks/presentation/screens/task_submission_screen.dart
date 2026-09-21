import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';
import 'package:workwise/core/design_system/widgets/buttons/app_button.dart';
import 'package:workwise/core/design_system/widgets/buttons/app_icon_button.dart';
import 'package:workwise/core/design_system/widgets/feedback/app_snack_bar.dart';
import 'package:workwise/core/design_system/widgets/inputs/app_text_field.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/features/tasks/presentation/widgets/custom_widgets/feedback.dart';
import 'package:workwise/generated/app_localizations.dart';
import '../../data/static_tasks_data.dart';
import '../../domain/models/task_models.dart';
import '../widgets/attachment_uploader.dart';
import '../widgets/custom_widgets/priority_badge.dart';
import '../widgets/progress_slider.dart';
import '../widgets/task_status_badge.dart';

class TaskSubmissionScreen extends StatefulWidget {
  const TaskSubmissionScreen({super.key, required this.task, this.onSubmitted});

  final Task task;
  final VoidCallback? onSubmitted;

  @override
  State<TaskSubmissionScreen> createState() => _TaskSubmissionScreenState();
}

class _TaskSubmissionScreenState extends State<TaskSubmissionScreen> {
  late final TextEditingController _notesController;
  late int _draftProgress;
  final List<TaskAttachment> _attachments = [];
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController();
    _draftProgress = widget.task.progress;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _updateProgress(double value) {
    setState(() => _draftProgress = value.round());
  }

  void _pickAttachment(List<TaskAttachment> newAttachments) {
    setState(() {
      _attachments.addAll(newAttachments);
    });
  }

  void _removeAttachment(TaskAttachment attachment) {
    setState(() {
      _attachments.remove(attachment);
    });
  }

  Future<void> _submitForReview() async {
    setState(() => _isSubmitting = true);

    // Simulate submission delay
    await Future.delayed(const Duration(milliseconds: 600));

    // Update static data
    StaticTasksData.updateTask(
      widget.task.id,
      _draftProgress,
      TaskStatus.underReview,
    );

    if (mounted) {
      final l10n = AppLocalizations.of(context);
      AppSnackBar.success(context, message: l10n.taskSubmittedSuccess);
      Navigator.of(context).pop();
      widget.onSubmitted?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Material(
      color: AppColors.onPrimary,
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            // Drag handle
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
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          'T-${widget.task.id}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        Gap(2.h),
                        AppText(
                          widget.task.title,
                          style: Theme.of(context).textTheme.titleMedium
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
            // Meta info
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                children: [
                  PriorityBadge(priority: widget.task.priority),
                  const Gap(8),
                  TaskStatusBadge(status: widget.task.status),
                  const Gap(12),
                  AppText(
                    '${l10n.due} ${_date(widget.task.deadline)}',
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
                    if (widget.task.feedback != null) ...[
                      Gap(16.h),
                      FeedbackCard(feedback: widget.task.feedback!),
                    ],
                    Gap(28.h),
                    ProgressSlider(
                      value: _draftProgress,
                      enabled: !_isSubmitting,
                      onChanged: _updateProgress,
                    ),
                    Gap(24.h),
                    AppTextField(
                      label: l10n.notes,
                      controller: _notesController,
                      enabled: !_isSubmitting,
                      type: AppTextFieldType.multiline,
                      minLines: 3,
                      maxLines: 5,
                      hintText: l10n.notesHint,
                    ),
                    Gap(24.h),
                    AttachmentUploader(
                      attachments: _attachments,
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
                text: l10n.submitForReview,
                onPressed: _submitForReview,
                isLoading: _isSubmitting,
                enabled: !_isSubmitting,
              ),
            ),
          ],
        ),
      ),
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
