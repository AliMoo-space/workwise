import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/typography/app_text_styles.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';

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
                    SizedBox(width: AppSpacing.space12.w),
                    Expanded(
                      child: AppText(
                        'Request Leave',
                        style: AppTextStyles.titleMedium,
                        softWrap: true,
                        // textScaler: TextScaler.noScaling,
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              ),
            ),
            SizedBox(width: AppSpacing.space16.w),
            Expanded(
              child: AppCard(
                height: 80.h,
                child: Row(
                  children: [
                    Icon(Icons.task_alt),
                    SizedBox(width: AppSpacing.space12.w),
                    Expanded(
                      child: AppText(
                        'Submet Task',
                        style: AppTextStyles.titleMedium,
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

        SizedBox(height: AppSpacing.space16.h),

        Row(
          children: [
            Expanded(
              child: AppCard(
                height: 80.h,
                child: Row(
                  children: [
                    Icon(Icons.calendar_month),
                    SizedBox(width: AppSpacing.space12.w),
                    Expanded(
                      child: AppText(
                        'View Calendar',
                        style: AppTextStyles.titleMedium,
                        softWrap: true,
                        // textScaler: TextScaler.noScaling,
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              ),
            ),
            SizedBox(width: AppSpacing.space16.w),
            Expanded(
              child: AppCard(
                height: 80.h,
                child: Row(
                  children: [
                    Icon(Icons.smart_toy_sharp),
                    SizedBox(width: AppSpacing.space12.w),
                    Expanded(
                      child: AppText(
                        'AI HR Assistant',
                        style: AppTextStyles.titleMedium,
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
