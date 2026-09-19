import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/typography/app_text_styles.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/layout/app_section.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';

class HomeStatsSectionWidget extends StatelessWidget {
  const HomeStatsSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppSection(
            child: AppCard(
              height: 160.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.task_alt_sharp),
                  Gap(AppSpacing.space12.h),
                  AppText('3', style: AppTextStyles.headlineSmall),
                  AppText(
                    context.l10n.pendingTasks,
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
              height: 160.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.calendar_month),
                  Gap(AppSpacing.space12.h),
                  AppText('June 12', style: AppTextStyles.headlineSmall),
                  AppText(
                    context.l10n.nextMeeting,
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
              height: 160.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.wallet_travel_outlined),
                  Gap(AppSpacing.space12.h),
                  AppText('13d', style: AppTextStyles.headlineSmall),
                  AppText(
                    context.l10n.leaveBalance,
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
