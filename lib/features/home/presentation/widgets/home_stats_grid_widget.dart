import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/typography/app_text_styles.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';

class HomeStatsGrid extends StatelessWidget {
  const HomeStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: AppCard(
                height: 80.h,
                child: Row(
                  children: [
                    Icon(Icons.calendar_today_outlined),
                    Gap(AppSpacing.space12.w),
                    Expanded(
                      child: AppText(
                        context.l10n.requestLeave,
                        style: AppTextStyles.titleSmall,
                        softWrap: true,
                        // textScaler: TextScaler.noScaling,
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              ),
            ),
            Gap(AppSpacing.space16.w),
            Expanded(
              child: AppCard(
                height: 80.h,
                child: Row(
                  children: [
                    Icon(Icons.task_alt),
                    Gap(AppSpacing.space12.w),
                    Expanded(
                      child: AppText(
                        context.l10n.submitTask,
                        style: AppTextStyles.titleSmall,
                        softWrap: true,
                        // textScaler: TextScaler.noScaling,
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              ),
            ),
          ],
        ),

        Gap(AppSpacing.space16.h),

        Row(
          children: [
            Expanded(
              child: AppCard(
                height: 80.h,
                child: Row(
                  children: [
                    Icon(Icons.calendar_month),
                    Gap(AppSpacing.space12.w),
                    Expanded(
                      child: AppText(
                        context.l10n.viewCalendar,
                        style: AppTextStyles.titleSmall,
                        softWrap: true,
                        // textScaler: TextScaler.noScaling,
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              ),
            ),
            Gap(AppSpacing.space16.w),
            Expanded(
              child: AppCard(
                height: 80.h,
                child: Row(
                  children: [
                    Icon(Icons.smart_toy_sharp),
                    Gap(AppSpacing.space12.w),
                    Expanded(
                      child: AppText(
                        context.l10n.aiHrAssistant,
                        style: AppTextStyles.titleSmall,
                        softWrap: true,
                        // textScaler: TextScaler.noScaling,
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
