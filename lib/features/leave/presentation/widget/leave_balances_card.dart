import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';

import 'package:workwise/core/design_system/spacing/app_radius.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';

import 'package:workwise/features/leave/domain/entity/leave_balance_entity.dart';

class LeaveBalancesCard extends StatelessWidget {
  const LeaveBalancesCard({super.key, required this.balance});

  final LeaveBalanceEntity balance;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final progress = balance.allocatedDays > 0
        ? (balance.usedDays / balance.allocatedDays).clamp(0.0, 1.0)
        : 0.0;

    return AppCard(
      height: 150.h,
      width: 110.w,
      padding: EdgeInsets.all(AppRadius.radius12.r),
      backgroundColor: theme.colorScheme.onError,
      borderRadius: AppRadius.radius32.r,
      border: Border.all(color: theme.colorScheme.outlineVariant, width: 1.w),
      boxShadow: const [],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            balance.name,
            style: theme.textTheme.titleSmall,
            textAlign: TextAlign.start,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          Gap(AppSpacing.space12.h),

          Row(
            children: [
              AppText(
                balance.remainingDays.toStringAsFixed(0),
                style: theme.textTheme.headlineMedium,
              ),
              AppText(
                '/${balance.allocatedDays.toStringAsFixed(0)}',
                style: theme.textTheme.labelLarge,
              ),
            ],
          ),

          AppText(
            context.l10n.daysLeft,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.start,
          ),

          Gap(AppSpacing.space12.h),

          LinearProgressIndicator(
            value: progress,
            backgroundColor: theme.colorScheme.outlineVariant,
            color: theme.colorScheme.tertiary,
            minHeight: 8.0.h,
            borderRadius: BorderRadius.circular(AppRadius.radius12.r),
          ),
        ],
      ),
    );
  }
}
