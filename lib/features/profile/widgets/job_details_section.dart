import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';

import 'package:workwise/core/design_system/colors/app_colors.dart';
import 'package:workwise/core/design_system/spacing/app_radius.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/typography/app_text_styles.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';

import 'job_detail_item.dart';

class JobDetailsSection extends StatelessWidget {
  const JobDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AppText(
              'Job details',
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
                borderRadius: BorderRadius.circular(
                  AppRadius.radius8.r,
                ),
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
                    'Managed by HR',
                    style: AppTextStyles.labelSmall,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ],
        ),

        Gap(AppSpacing.space16.h),

        const JobDetailItem(
          icon: Icons.person_outline,
          label: 'DIRECT MANAGER',
          title: 'Layla Nasser',
          subtitle: 'Head of Operations',
          showButton: true,
        ),

        Gap(AppSpacing.space12.h),

        const JobDetailItem(
          icon: Icons.location_on_outlined,
          label: 'WORK LOCATION',
          title: 'Downtown Campus\n— Tower B',
          badge: 'Within\nassigned\nradius',
          badgeColor: AppColors.accent,
        ),

        Gap(AppSpacing.space12.h),

        const JobDetailItem(
          icon: Icons.email_outlined,
          label: 'WORK EMAIL',
          title: 'omar.haddad@smarthr.co',
        ),

        Gap(AppSpacing.space12.h),

        const JobDetailItem(
          icon: Icons.phone_outlined,
          label: 'WORK PHONE',
          title: '+971 4 555 0192',
        ),
      ],
    );
  }
}