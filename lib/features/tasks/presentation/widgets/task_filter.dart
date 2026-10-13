import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';
import 'package:workwise/features/tasks/domain/models/task_models.dart';

class TaskFilterBar extends StatelessWidget {
  const TaskFilterBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final TaskFilter selected;
  final ValueChanged<TaskFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    final labels = {
      TaskFilter.all: context.l10n.all,
      TaskFilter.inProgress: context.l10n.inProgress,
      TaskFilter.underReview: context.l10n.underReview,
      TaskFilter.completed: context.l10n.completed,
    };

    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: TaskFilter.values.length,
        separatorBuilder: (_, _) => Gap(4.w),
        itemBuilder: (context, index) {
          final filter = TaskFilter.values[index];
          return ChoiceChip(
            label: AppText(labels[filter]!, style: TextStyle(fontSize: 12.sp)),
            selected: selected == filter,
            onSelected: (_) => onSelected(filter),
            shape: const StadiumBorder(),
            showCheckmark: false,
            selectedColor: AppColors.textSecondary,
          );
        },
      ),
    );
  }
}
