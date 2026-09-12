import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/typography/app_text_styles.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/layout/app_section.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';

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
                  SizedBox(height: AppSpacing.space12.h),
                  AppText('3', style: AppTextStyles.headlineSmall),
                  AppText(
                    'Pending Tasks',
                    style: AppTextStyles.headlineSmall.copyWith(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),

        SizedBox(width: AppSpacing.space16.w),

        Expanded(
          child: AppSection(
            child: AppCard(
              height: 160.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.calendar_month),
                  SizedBox(height: AppSpacing.space12.h),
                  AppText('June 12', style: AppTextStyles.headlineSmall),
                  AppText('Next Meeting', style: AppTextStyles.bodySmall),
                ],
              ),
            ),
          ),
        ),

        SizedBox(width: AppSpacing.space16.w),

        Expanded(
          child: AppSection(
            child: AppCard(
              height: 160.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.wallet_travel_outlined),
                  SizedBox(height: AppSpacing.space12.h),
                  AppText('13d', style: AppTextStyles.headlineSmall),
                  AppText(
                    'Leave Balance',
                    style: AppTextStyles.headlineSmall.copyWith(fontSize: 16),
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
