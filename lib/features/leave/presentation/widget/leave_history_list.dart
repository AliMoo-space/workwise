import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';

import 'package:workwise/core/design_system/spacing/app_radius.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';

import 'package:workwise/features/leave/domain/entity/leave_history_entity.dart';

class LeaveHistoryList extends StatelessWidget {
  const LeaveHistoryList({super.key, required this.leaveHistory});

  final List<LeaveHistoryEntity> leaveHistory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Latest leave request first.
    final sortedLeaveHistory = [...leaveHistory]
      ..sort((a, b) {
        final dateA = DateTime.tryParse(a.createdAt);
        final dateB = DateTime.tryParse(b.createdAt);

        // Invalid dates go to the end.
        if (dateA == null && dateB == null) {
          return 0;
        }

        if (dateA == null) {
          return 1;
        }

        if (dateB == null) {
          return -1;
        }

        // Latest created request first.
        return dateB.compareTo(dateA);
      });

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedLeaveHistory.length,
      itemBuilder: (context, index) {
        final leave = sortedLeaveHistory[index];

        return AppCard(
          margin: EdgeInsets.only(bottom: AppSpacing.space8.h),
          height: 80.h,
          width: double.infinity,
          padding: EdgeInsets.all(10.r),
          backgroundColor: theme.colorScheme.onError,
          borderRadius: AppRadius.radius20.r,
          border: Border.all(
            color: theme.colorScheme.outlineVariant,
            width: .7.w,
          ),
          boxShadow: const [],
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(leave.name, style: theme.textTheme.titleSmall),
                    AppText(
                      '${_formatDate(context, leave.startDate)} - '
                      '${_formatDate(context, leave.endDate)} · '
                      '${leave.days} ${context.l10n.days}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Gap(AppSpacing.space8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                height: 30.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.radius16.r),
                  color: theme.colorScheme.outlineVariant,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 10.h,
                      width: 10.w,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Gap(AppSpacing.space8.w),
                    AppText(leave.status, style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(BuildContext context, String date) {
    final parsedDate = DateTime.tryParse(date);

    if (parsedDate == null) {
      return date;
    }

    final months = [
      context.l10n.january,
      context.l10n.february,
      context.l10n.march,
      context.l10n.april,
      context.l10n.may,
      context.l10n.june,
      context.l10n.july,
      context.l10n.august,
      context.l10n.september,
      context.l10n.october,
      context.l10n.november,
      context.l10n.december,
    ];

    return '${parsedDate.day} ${months[parsedDate.month - 1]}';
  }
}
