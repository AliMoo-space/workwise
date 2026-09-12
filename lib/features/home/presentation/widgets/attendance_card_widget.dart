import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/typography/app_text_styles.dart';
import 'package:workwise/core/design_system/widgets/buttons/app_button.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';

class AttendanceCardWidget extends StatelessWidget {
  const AttendanceCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      backgroundColor: AppColors.primary.withValues(alpha: .9),

      // margin: EdgeInsets.all(AppSpacing.space12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AppText(
                  "Today's attendance",
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.disabled,
                  ),
                ),
              ),
              AppCard(
                height: AppSpacing.space40.h,
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.space12.w),
                backgroundColor: AppColors.outlineVariant.withValues(alpha: .2),
                child: Center(
                  child: AppText(
                    'On Shift',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.onPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.space4.h),
          AppText(
            'Checked in at 9:00 AM',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppSpacing.space12.h),
          Row(
            children: [
              Icon(Icons.access_time, color: AppColors.onPrimary),
              SizedBox(width: AppSpacing.space8.w),
              AppText(
                '03:20:51 ',
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.onPrimary,
                  fontSize: 35.sp,
                ),
              ),
              AppText(
                'hours worked',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.onPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.space12.h),
          Row(
            children: [
              Icon(Icons.location_on_outlined, color: AppColors.onPrimary),
              SizedBox(width: AppSpacing.space8.w),
              AppText(
                'Inside the office',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.onPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.space12.h),
          AppButton(
            text: 'Check Out',
            backgroundColor: AppColors.outlineVariant.withValues(alpha: .4),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
