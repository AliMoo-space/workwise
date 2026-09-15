import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/typography/app_text_styles.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/generated/app_localizations.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({
    super.key,
    this.icon = Icons.assignment_turned_in_outlined,
    this.title,
    this.message,
    this.iconSize = 48,
    this.iconColor,
  });

  final IconData icon;
  final String? title;
  final String? message;
  final double iconSize;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: iconSize.r,
              color: iconColor ?? Theme.of(context).colorScheme.primary,
            ),
            Gap(12.h),
            AppText(title ?? l10n.noTasksHere, style: AppTextStyles.titleLarge),
            Gap(6.h),
            AppText(
              message ?? l10n.noTasksMessage,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
