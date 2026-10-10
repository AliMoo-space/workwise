import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:workwise/core/design_system/spacing/app_radius.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/localization/localization_extension.dart';

class PerformanceLoadingView {
  static Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.space16),
        child: Skeletonizer(
          enabled: true,
          effect: const ShimmerEffect(
            baseColor: Color(0xFFF7F9FB),
            highlightColor: Color(0xFFFFFFFF),
            duration: Duration(milliseconds: 1400),
          ),
          child: Column(
            children: [
              _buildMonthlyPerformanceSkeleton(context),

              const Gap(AppSpacing.space8),

              Align(
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  context.l10n.atAGlance,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),

              const Gap(AppSpacing.space8),

              _buildOverviewSkeleton(context),

              const Gap(AppSpacing.space8),

              Align(
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  context.l10n.performanceTrend,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),

              const Gap(AppSpacing.space8),

              _buildChartSkeleton(context),

              const Gap(AppSpacing.space8),

              Row(
                children: [
                  Text(
                    context.l10n.personalGoals,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  Text(
                    context.l10n.view,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),

              const Gap(AppSpacing.space8),

              _buildGoalsSkeleton(context),

              const Gap(AppSpacing.space8),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildMonthlyPerformanceSkeleton(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      height: 180.h,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      backgroundColor: const Color(0xFFF7F9FB),
      borderRadius: AppRadius.radius20.r,
      border: Border.all(color: theme.colorScheme.outlineVariant, width: 1.w),
      boxShadow: const [],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Bone(
                width: 90.w,
                height: 16.h,
                borderRadius: BorderRadius.circular(AppRadius.radius4.r),
              ),
              Gap(AppSpacing.space8.h),
              Bone(
                width: 130.w,
                height: 20.h,
                borderRadius: BorderRadius.circular(AppRadius.radius4.r),
              ),
              Gap(AppSpacing.space8.h),
              Bone(
                width: 120.w,
                height: 16.h,
                borderRadius: BorderRadius.circular(AppRadius.radius4.r),
              ),
            ],
          ),
          Bone(
            width: 100.w,
            height: 100.w,
            borderRadius: BorderRadius.circular(100.r),
          ),
        ],
      ),
    );
  }

  static Widget _buildOverviewSkeleton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildOverviewCardSkeleton(),
        _buildOverviewCardSkeleton(),
        _buildOverviewCardSkeleton(),
      ],
    );
  }

  static Widget _buildOverviewCardSkeleton() {
    return AppCard(
      height: 100.h,
      width: 110.w,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.space16.w),
      borderRadius: AppRadius.radius16.r,
      boxShadow: const [],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Bone(
            width: 55.w,
            height: 24.h,
            borderRadius: BorderRadius.circular(AppRadius.radius4.r),
          ),
          Gap(AppSpacing.space8.h),
          Bone(
            width: 65.w,
            height: 14.h,
            borderRadius: BorderRadius.circular(AppRadius.radius4.r),
          ),
        ],
      ),
    );
  }

  static Widget _buildChartSkeleton(BuildContext context) {
    return AppCard(
      height: 180.h,
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.space16.r),
      backgroundColor: Theme.of(context).colorScheme.onError,
      borderRadius: AppRadius.radius16.r,
      border: Border.all(
        color: Theme.of(context).colorScheme.outlineVariant,
        width: 1.w,
      ),
      boxShadow: const [],
      child: Bone(
        width: double.infinity,
        height: 120.h,
        borderRadius: BorderRadius.circular(AppRadius.radius8.r),
      ),
    );
  }

  static Widget _buildGoalsSkeleton(BuildContext context) {
    return Column(
      children: [
        _buildGoalCardSkeleton(context),
        Gap(AppSpacing.space12.h),
        _buildGoalCardSkeleton(context),
      ],
    );
  }

  static Widget _buildGoalCardSkeleton(BuildContext context) {
    return AppCard(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.space16.r),
      backgroundColor: Theme.of(context).colorScheme.onError,
      borderRadius: AppRadius.radius20.r,
      border: Border.all(
        color: Theme.of(context).colorScheme.outlineVariant,
        width: .7.w,
      ),
      boxShadow: const [],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Bone(
                  height: 20.h,
                  borderRadius: BorderRadius.circular(AppRadius.radius4.r),
                ),
              ),
              Gap(AppSpacing.space12.w),
              Bone(
                width: 90.w,
                height: 32.h,
                borderRadius: BorderRadius.circular(AppRadius.radius32.r),
              ),
            ],
          ),
          Gap(AppSpacing.space12.h),
          Bone(
            width: double.infinity,
            height: 16.h,
            borderRadius: BorderRadius.circular(AppRadius.radius4.r),
          ),
          Gap(AppSpacing.space8.h),
          Bone(
            width: 220.w,
            height: 16.h,
            borderRadius: BorderRadius.circular(AppRadius.radius4.r),
          ),
          Gap(AppSpacing.space16.h),
          Row(
            children: [
              Bone(
                width: 16.w,
                height: 16.w,
                borderRadius: BorderRadius.circular(AppRadius.radius4.r),
              ),
              Gap(AppSpacing.space8.w),
              Bone(
                width: 120.w,
                height: 14.h,
                borderRadius: BorderRadius.circular(AppRadius.radius4.r),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
