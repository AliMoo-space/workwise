import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';
import 'package:workwise/core/design_system/spacing/app_radius.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/typography/app_text_styles.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';
import 'package:workwise/features/profile/domain/entities/profile.dart';

class EmployeeInfo extends StatelessWidget {
  const EmployeeInfo({super.key, required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.space16.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(AppRadius.radius12.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: _InfoItem(
              label: context.l10n.profileEmployeeId,
              value: profile.employeeCode,
            ),
          ),

          Gap(AppSpacing.space16.w),

          Expanded(
            child: _InfoItem(
              label: context.l10n.profileJoined,
              value: profile.startDate,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          label,
          style: AppTextStyles.labelSmall,
          color: AppColors.textSecondary,
        ),

        Gap(AppSpacing.space4.h),

        AppText(value, style: AppTextStyles.titleMedium, fontSize: 14.sp),
      ],
    );
  }
}
