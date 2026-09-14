import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/typography/app_text_styles.dart';
import 'package:workwise/core/design_system/widgets/buttons/app_button.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';

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
                  context.l10n.todayAttendance,
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
                    context.l10n.onShift,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.onPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Gap(AppSpacing.space4.h),
          AppText(
            context.l10n.checkedInAt,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Gap(AppSpacing.space12.h),
          Row(
            children: [
              Icon(Icons.access_time, color: AppColors.onPrimary),
              Gap(AppSpacing.space8.w),
              AppText(
                '03:20:51 ',
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.onPrimary,
                  fontSize: 35.sp,
                ),
              ),
              AppText(
                context.l10n.hoursWorked,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.onPrimary,
                ),
              ),
            ],
          ),
          Gap(AppSpacing.space12.h),
          Row(
            children: [
              Icon(Icons.location_on_outlined, color: AppColors.onPrimary),
              Gap(AppSpacing.space8.w),
              AppText(
                context.l10n.insideOffice,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.onPrimary,
                ),
              ),
            ],
          ),
          Gap(AppSpacing.space12.h),
          AppButton(
            text: context.l10n.checkOut,
            backgroundColor: AppColors.outlineVariant.withValues(alpha: .4),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
