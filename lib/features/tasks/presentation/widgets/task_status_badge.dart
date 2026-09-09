import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../domain/models/task_models.dart';

class TaskStatusBadge extends StatelessWidget {
  const TaskStatusBadge({super.key, required this.status});

  final TaskStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      TaskStatus.inProgress => ('In Progress', Colors.blue),
      TaskStatus.underReview => ('Under Review', Colors.orange),
      TaskStatus.completed => ('Completed', Colors.green),
    };
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: Color.fromRGBO(
          color.red,
          color.green,
          color.blue,
          0.12,
        ),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 5.w),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
                fontSize: 13.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
