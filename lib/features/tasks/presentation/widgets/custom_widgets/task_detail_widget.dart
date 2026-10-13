import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';

class TaskDetailWidget extends StatelessWidget {
  const TaskDetailWidget({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        icon,
        size: 17.r,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      Gap(7.w),
      Flexible(
        child: AppText(
          text,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontSize: 12.sp),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}
