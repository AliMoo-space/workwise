import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';

import 'package:workwise/core/design_system/colors/app_colors.dart';
import 'package:workwise/core/design_system/spacing/app_radius.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/typography/app_text_styles.dart';
import 'package:workwise/core/design_system/widgets/buttons/app_button.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';

class JobDetailItem extends StatelessWidget {
  const JobDetailItem({
    super.key,
    required this.icon,
    required this.label,
    required this.title,
    this.subtitle,
    this.showButton = false,
    this.badge,
    this.badgeColor,
  });

  final IconData icon;
  final String label;
  final String title;
  final String? subtitle;
  final bool showButton;
  final String? badge;
  final Color? badgeColor;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.all(AppSpacing.space12.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(AppSpacing.space8.w),

          Expanded(child: _buildContent()),

          if (showButton) ...[Gap(AppSpacing.space8.w), _buildContactButton()],

          if (badge != null) ...[Gap(AppSpacing.space8.w), _buildBadge()],

          Gap(AppSpacing.space8.w),

          Icon(Icons.lock_outline, size: 16.r, color: AppColors.textSecondary),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20.r, color: AppColors.textSecondary),
            Gap(AppSpacing.space4.w),

            AppText(
              label,
              style: AppTextStyles.labelSmall,
              color: AppColors.textSecondary,
            ),
          ],
        ),

        Gap(AppSpacing.space4.h),

        AppText(title, style: AppTextStyles.titleMedium, fontSize: 14.sp),

        if (subtitle != null) ...[
          Gap(AppSpacing.space2.h),

          AppText(
            subtitle!,
            style: AppTextStyles.bodySmall,
            color: AppColors.textSecondary,
          ),
        ],
      ],
    );
  }

  Widget _buildContactButton() {
    return AppButton(
      text: 'Contact',
      fontSize: 10.sp,
      onPressed: () {},
      variant: AppButtonVariant.secondary,
      height: 40.h,
      width: 100.w,
    );
  }

  Widget _buildBadge() {
    return Container(
      constraints: BoxConstraints(minWidth: 90.w),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.space8.w,
        vertical: AppSpacing.space8.h,
      ),
      decoration: BoxDecoration(
        color: (badgeColor ?? AppColors.accent).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.radius16.r),
      ),
      child: AppText(
        badge!,
        style: AppTextStyles.labelSmall,
        color: badgeColor ?? AppColors.accent,
        textAlign: TextAlign.center,
      ),
    );
  }
}
