import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../domain/models/task_models.dart';
import 'task_status_badge.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task, required this.onTap});

  final Task task;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.only(bottom: 12.h),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontSize: 16.sp),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 5.w),
                PriorityBadge(priority: task.priority),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                _Detail(icon: Icons.person_outline, text: task.managerName),
                SizedBox(width: 20.w),
                _Detail(
                  icon: Icons.calendar_today_outlined,
                  text: 'Due ${_date(task.deadline)}',
                ),
              ],
            ),

            SizedBox(height: 5.h),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(value: task.progress / 100),
                ),
                SizedBox(width: 12.w),
                Text('${task.progress}%', style: TextStyle(fontSize: 14.sp)),
              ],
            ),
            SizedBox(height: 10.h),
            TaskStatusBadge(status: task.status),
          ],
        ),
      ),
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

class _Detail extends StatelessWidget {
  const _Detail({required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        icon,
        size: 17.sp,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      SizedBox(width: 7.w),
      Flexible(
        child: Text(
          text,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}

class PriorityBadge extends StatelessWidget {
  const PriorityBadge({super.key, required this.priority});
  final TaskPriority priority;
  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (priority) {
      TaskPriority.low => ('Low', Colors.green),
      TaskPriority.medium => ('Medium', Colors.orange),
      TaskPriority.high => ('High', Colors.red),
      TaskPriority.urgent => ('Urgent', Colors.purple),
    };
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: Color.fromRGBO(color.red, color.green, color.blue, 0.12),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: 5.w),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}
