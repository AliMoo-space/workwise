import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../domain/models/task_models.dart';

class TaskFilterBar extends StatelessWidget {
  const TaskFilterBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final TaskFilter selected;
  final ValueChanged<TaskFilter> onSelected;

  static const _labels = {
    TaskFilter.all: 'All',
    TaskFilter.inProgress: 'In Progress',
    TaskFilter.underReview: 'Under Review',
    TaskFilter.completed: 'Completed',
  };

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 35.h,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: TaskFilter.values.length,
      separatorBuilder: (_, __) => SizedBox(width: 8.w),
      itemBuilder: (context, index) {
        final filter = TaskFilter.values[index];
        return ChoiceChip(
          label: Text(_labels[filter]!, style: TextStyle(fontSize: 12.sp)),
          selected: selected == filter,
          onSelected: (_) => onSelected(filter),
          shape: const StadiumBorder(),
          showCheckmark: false,
        );
      },
    ),
  );
}
