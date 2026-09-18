import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';

import '../../domain/models/task_models.dart';
import 'custom_widgets/priority_badge.dart';
import 'custom_widgets/task_detail_widget.dart';
import 'task_status_badge.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task, required this.onTap});

  final Task task;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => AppCard(
    margin: EdgeInsets.only(bottom: 12.h),
    padding: EdgeInsets.all(16.w),
    onTap: onTap,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: AppText(
                task.title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontSize: 16.sp),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Gap(5.w),
            PriorityBadge(priority: task.priority),
          ],
        ),
        Gap(10.h),
        Row(
          children: [
            TaskDetailWidget(
              icon: Icons.person_outline,
              text: task.managerName,
            ),
            Gap(20.w),
            TaskDetailWidget(
              icon: Icons.calendar_today_outlined,
              text: '${context.l10n.due} ${_date(task.deadline)}',
            ),
          ],
        ),
        Gap(5.h),
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(value: task.progress / 100),
            ),
            Gap(12.w),
            Text('${task.progress}%', style: TextStyle(fontSize: 14.sp)),
          ],
        ),
        Gap(10.h),
        TaskStatusBadge(status: task.status),
      ],
    ),
  );

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
