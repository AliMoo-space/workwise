import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart' show Gap;
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_radius.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_text_styles.dart';

class DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const DrawerMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.space12.h,
        vertical: AppSpacing.space4.w,
      ),
      child: Material(
        color: isSelected ? AppColors.selected : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.radius12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.radius12.r),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.space16.h,
              vertical: AppSpacing.space12.w,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 24.r,
                  color: isSelected
                      ? AppColors.accent
                      : AppColors.textSecondary,
                ),
                Gap(16.w),
                Expanded(
                  child: AppText(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isSelected
                          ? AppColors.accent
                          : AppColors.textPrimary,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
