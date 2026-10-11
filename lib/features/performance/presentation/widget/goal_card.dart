import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:workwise/core/design_system/spacing/app_radius.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';
import 'package:workwise/features/performance/domain/goals/entities/goal.dart';

class GoalCard extends StatelessWidget {
  final Goal? goal;
  final bool isLoading;
  final VoidCallback? onTap;

  const GoalCard({super.key, this.goal, this.isLoading = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AppCard(
        width: double.infinity,
        padding: EdgeInsets.all(AppSpacing.space16.r),
        backgroundColor: theme.colorScheme.onError,
        borderRadius: AppRadius.radius20.r,
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
          width: .7.w,
        ),
        boxShadow: const [],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        isLoading
                            ? 'Complete Laravel Refactoring'
                            : goal!.title,
                        style: theme.textTheme.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                      ),

                      Gap(AppSpacing.space4.h),

                      AppText(
                        isLoading
                            ? 'Clean up legacy API documentation and controllers.'
                            : goal!.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),

                Gap(AppSpacing.space12.w),

                _buildStatus(context),
              ],
            ),

            Gap(AppSpacing.space20.h),

            _buildTargetDate(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatus(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      width: 92.w,
      height: 32.h,
      padding: EdgeInsets.zero,
      backgroundColor: theme.colorScheme.outlineVariant.withValues(alpha: .55),
      borderRadius: AppRadius.radius32.r,
      border: Border.all(color: Colors.transparent),
      boxShadow: const [],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading) ...[
            Bone(
              width: 7.w,
              height: 7.h,
              borderRadius: BorderRadius.circular(AppRadius.radius16.r),
            ),
            Gap(AppSpacing.space4.w),
            Bone(
              width: 42.w,
              height: 13.h,
              borderRadius: BorderRadius.circular(AppRadius.radius4.r),
            ),
          ] else ...[
            Container(
              width: 7.w,
              height: 7.w,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),

            Gap(AppSpacing.space4.w),

            Flexible(
              child: AppText(
                goal!.status,
                style: theme.textTheme.labelMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTargetDate(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          Icons.calendar_today_outlined,
          size: 15.sp,
          color: theme.colorScheme.onSurfaceVariant,
        ),

        Gap(AppSpacing.space8.w),

        if (isLoading)
          Bone(
            width: 120.w,
            height: 14.h,
            borderRadius: BorderRadius.circular(AppRadius.radius4.r),
          )
        else
          AppText(
            '${context.l10n.target} ${goal!.targetDate}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.start,
          ),
      ],
    );
  }
}
