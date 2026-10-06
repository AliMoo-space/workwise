import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/typography/app_text_styles.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/layout/app_section.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';
import 'package:workwise/features/attendance/domain/entities/attendance_entity.dart';

class HomeStatsSectionWidget extends StatelessWidget {
  const HomeStatsSectionWidget({super.key, this.widgets});

  final AttendanceWidgetsEntity? widgets;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppSection(
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.task_alt_sharp),
                  Gap(AppSpacing.space12.h),
                  AppText(
                    '${widgets?.pendingTasks?.count ?? 0}',
                    style: AppTextStyles.headlineSmall,
                  ),
                  AppText(
                    widgets?.pendingTasks?.label ?? context.l10n.pendingTasks,
                    style: AppTextStyles.headlineSmall.copyWith(
                      fontSize: 15.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Gap(AppSpacing.space16.w),
        Expanded(
          child: AppSection(
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.calendar_month),
                  Gap(AppSpacing.space12.h),
                  AppText(
                    widgets?.nextDeadline?.date ?? '-',
                    style: AppTextStyles.headlineSmall,
                  ),
                  AppText(
                    widgets?.nextDeadline?.label ?? context.l10n.nextMeeting,
                    style: AppTextStyles.bodySmall.copyWith(fontSize: 10.sp),
                  ),
                ],
              ),
            ),
          ),
        ),
        Gap(AppSpacing.space16.w),
        Expanded(
          child: AppSection(
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.wallet_travel_outlined),
                  Gap(AppSpacing.space12.h),
                  AppText(
                    widgets?.leaveBalance?.days == null
                        ? '-'
                        : '${widgets!.leaveBalance!.days}d',
                    style: AppTextStyles.headlineSmall,
                  ),
                  AppText(
                    widgets?.leaveBalance?.label ?? context.l10n.leaveBalance,
                    style: AppTextStyles.headlineSmall.copyWith(
                      fontSize: 15.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
