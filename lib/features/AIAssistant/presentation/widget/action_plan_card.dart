import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';

import 'package:workwise/core/design_system/spacing/app_radius.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/features/AIAssistant/domain/entities/career_coach.dart';

class ActionPlanCard extends StatelessWidget {
  final DevelopmentPlan plan;
  final int index;

  const ActionPlanCard({super.key, required this.plan, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      width: double.infinity,
      padding: EdgeInsets.zero,
      backgroundColor: theme.colorScheme.onError,
      borderRadius: AppRadius.radius24.r,
      border: Border.all(color: theme.colorScheme.outlineVariant),
      boxShadow: const [],
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.space12.r),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step Number
            Container(
              height: 40.h,
              width: 40.w,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(AppRadius.radius12.r),
              ),
              child: Center(
                child: AppText(
                  '${index + 1}',
                  color: theme.colorScheme.onPrimary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            Gap(AppSpacing.space12.w),

            // Action Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    'Action ${index + 1}',
                    fontSize: 11.sp,
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),

                  Gap(AppSpacing.space4.h),

                  // Action
                  AppText(
                    plan.action,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  Gap(AppSpacing.space12.h),

                  // Timeline
                  Container(
                    constraints: BoxConstraints(maxWidth: 150.w),
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.space8.w,
                      vertical: AppSpacing.space4.h,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(AppRadius.radius16.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 14.sp,
                          color: theme.colorScheme.primary,
                        ),

                        Gap(AppSpacing.space4.w),

                        Flexible(
                          child: AppText(
                            plan.suggestedTimeline,
                            fontSize: 11.sp,
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
