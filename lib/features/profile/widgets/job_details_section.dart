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

import 'job_detail_item.dart';

class JobDetailsSection extends StatelessWidget {
  const JobDetailsSection({super.key, required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AppText(
              context.l10n.profileJobDetails,
              style: AppTextStyles.titleLarge,
            ),

            const Spacer(),

            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.space8.w,
                vertical: AppSpacing.space4.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(AppRadius.radius8.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 14.r,
                    color: AppColors.textSecondary,
                  ),

                  Gap(AppSpacing.space4.w),

                  AppText(
                    context.l10n.profileManagedByHr,
                    style: AppTextStyles.labelSmall,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ],
        ),

        Gap(AppSpacing.space16.h),

        JobDetailItem(
          icon: Icons.person_outline,
          label: context.l10n.profileDirectManager,
          title: profile.managerName ?? '-',
          badge: context.l10n.profileHeadOfOperations,
          showButton: true,
        ),

        Gap(AppSpacing.space12.h),

        JobDetailItem(
          icon: Icons.location_on_outlined,
          label: context.l10n.profileWorkLocation,
          title: profile.companyLocationName ?? profile.address,
          badge: context.l10n.profileWithinAssignedRadius,
          badgeColor: AppColors.accent,
        ),

        Gap(AppSpacing.space12.h),

        JobDetailItem(
          icon: Icons.email_outlined,
          label: context.l10n.profileWorkEmail,
          title: profile.email,
        ),

        Gap(AppSpacing.space12.h),

        JobDetailItem(
          icon: Icons.phone_outlined,
          label: context.l10n.profileWorkPhone,
          title: profile.phone,
        ),
      ],
    );
  }
}
