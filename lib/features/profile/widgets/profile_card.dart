import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/typography/app_text_styles.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/media/app_network_image.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';

import 'employee_info.dart';
import 'profile_status_badge.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.all(AppSpacing.space16.r),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppNetworkImage(
                imageUrl: 'https://via.placeholder.com/120',
                width: 80.w,
                height: 80.h,
                shape: BoxShape.circle,
                fit: BoxFit.cover,
                backgroundColor: AppColors.surfaceContainer,
                errorWidget: _buildAvatarFallback(),
              ),

              Gap(AppSpacing.space16.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText('Omar Haddad', style: AppTextStyles.headlineMedium),

                    Gap(AppSpacing.space4.h),

                    AppText(
                      'Senior Product Analyst',
                      style: AppTextStyles.bodyMedium,
                      color: AppColors.textSecondary,
                    ),

                    Gap(AppSpacing.space2.h),

                    AppText(
                      'Operations / Product',
                      style: AppTextStyles.bodySmall,
                      color: AppColors.textSecondary,
                    ),

                    Gap(AppSpacing.space8.h),

                    ProfileStatusBadge(
                      text: context.l10n.profileActiveFullTime,
                    ),
                  ],
                ),
              ),
            ],
          ),

          Gap(AppSpacing.space16.h),

          const EmployeeInfo(),
        ],
      ),
    );
  }

  Widget _buildAvatarFallback() {
    return Container(
      width: 72.w,
      height: 72.h,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surfaceContainer,
      ),
      alignment: Alignment.center,
      child: AppText(
        'OH',
        style: AppTextStyles.titleLarge,
        color: AppColors.textPrimary,
      ),
    );
  }
}
