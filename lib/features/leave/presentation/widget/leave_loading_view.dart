import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:workwise/core/design_system/spacing/app_radius.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';

final class LeaveLoadingView {
  const LeaveLoadingView._();

  static Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.space16),
        child: Skeletonizer(
          enabled: true,
          effect: const ShimmerEffect(
            baseColor: Color(0xFFF0F3F5),
            highlightColor: Color(0xFFFAFBFC),
            duration: Duration(milliseconds: 1700),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Leave Header
              Bone(
                width: 70.w,
                height: 24.h,
                borderRadius: BorderRadius.circular(AppRadius.radius4.r),
              ),

              Gap(AppSpacing.space8.h),

              Bone(
                width: 180.w,
                height: 14.h,
                borderRadius: BorderRadius.circular(AppRadius.radius4.r),
              ),

              Gap(AppSpacing.space16.h),

              // Leave Balances
              SizedBox(
                height: 150.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  separatorBuilder: (_, __) {
                    return const Gap(AppSpacing.space8);
                  },
                  itemBuilder: (context, index) {
                    return _buildBalanceSkeleton(context);
                  },
                ),
              ),

              Gap(AppSpacing.space8.h),

              // Request Leave Title
              Bone(
                width: 130.w,
                height: 20.h,
                borderRadius: BorderRadius.circular(AppRadius.radius4.r),
              ),

              Gap(AppSpacing.space8.h),

              // Request Leave Form
              _buildRequestFormSkeleton(context),

              Gap(AppSpacing.space16.h),

              // Leave History Title
              Bone(
                width: 120.w,
                height: 20.h,
                borderRadius: BorderRadius.circular(AppRadius.radius4.r),
              ),

              Gap(AppSpacing.space8.h),

              // Leave History
              _buildHistorySkeleton(context),

              Gap(AppSpacing.space8.h),
            ],
          ),
        ),
      ),
    );
  }

  // Leave Balance Skeleton

  static Widget _buildBalanceSkeleton(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      height: 150.h,
      width: 110.w,
      padding: EdgeInsets.all(AppRadius.radius12.r),
      backgroundColor: const Color(0xFFF7F9FB),
      borderRadius: AppRadius.radius32.r,
      border: Border.all(color: theme.colorScheme.outlineVariant, width: 1.w),
      boxShadow: const [],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Bone(
            width: 80.w,
            height: 16.h,
            borderRadius: BorderRadius.circular(AppRadius.radius4.r),
          ),

          Gap(AppSpacing.space12.h),

          Row(
            children: [
              Bone(
                width: 35.w,
                height: 30.h,
                borderRadius: BorderRadius.circular(AppRadius.radius4.r),
              ),

              Gap(AppSpacing.space4.w),

              Bone(
                width: 35.w,
                height: 16.h,
                borderRadius: BorderRadius.circular(AppRadius.radius4.r),
              ),
            ],
          ),

          Gap(AppSpacing.space4.h),

          Bone(
            width: 55.w,
            height: 14.h,
            borderRadius: BorderRadius.circular(AppRadius.radius4.r),
          ),

          Gap(AppSpacing.space12.h),

          Bone(
            width: double.infinity,
            height: 8.h,
            borderRadius: BorderRadius.circular(AppRadius.radius12.r),
          ),
        ],
      ),
    );
  }

  // Request Leave Form Skeleton

  static Widget _buildRequestFormSkeleton(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      width: double.infinity,
      padding: EdgeInsets.all(AppRadius.radius16.r),
      backgroundColor: const Color(0xFFF7F9FB),
      borderRadius: AppRadius.radius20.r,
      border: Border.all(color: theme.colorScheme.outlineVariant, width: 1.w),
      boxShadow: const [],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Start Date + End Date
          Row(
            children: [
              Expanded(child: _buildInputSkeleton(labelWidth: 75.w)),

              Gap(AppSpacing.space8.w),

              Expanded(child: _buildInputSkeleton(labelWidth: 75.w)),
            ],
          ),

          Gap(AppSpacing.space16.h),

          // Leave Type
          _buildInputSkeleton(labelWidth: 85.w),

          Gap(AppSpacing.space16.h),

          // Reason
          Bone(
            width: 65.w,
            height: 14.h,
            borderRadius: BorderRadius.circular(AppRadius.radius4.r),
          ),

          Gap(AppSpacing.space8.h),

          Bone(
            width: double.infinity,
            height: 65.h,
            borderRadius: BorderRadius.circular(AppRadius.radius12.r),
          ),

          Gap(AppSpacing.space16.h),

          // Attachment
          Bone(
            width: double.infinity,
            height: 130.h,
            borderRadius: BorderRadius.circular(AppRadius.radius16.r),
          ),

          Gap(AppSpacing.space8.h),

          // Submit Button
          Bone(
            width: double.infinity,
            height: 48.h,
            borderRadius: BorderRadius.circular(AppRadius.radius12.r),
          ),
        ],
      ),
    );
  }

  // Input Skeleton

  static Widget _buildInputSkeleton({required double labelWidth}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Bone(
          width: labelWidth,
          height: 14.h,
          borderRadius: BorderRadius.circular(AppRadius.radius4.r),
        ),

        Gap(AppSpacing.space8.h),

        Bone(
          width: double.infinity,
          height: 48.h,
          borderRadius: BorderRadius.circular(AppRadius.radius12.r),
        ),
      ],
    );
  }

  // Leave History Skeleton

  static Widget _buildHistorySkeleton(BuildContext context) {
    return Column(
      children: [
        _buildHistoryCardSkeleton(context),
        Gap(AppSpacing.space8.h),
        _buildHistoryCardSkeleton(context),
      ],
    );
  }

  static Widget _buildHistoryCardSkeleton(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      margin: EdgeInsets.only(bottom: AppSpacing.space8.h),
      height: 80.h,
      width: double.infinity,
      padding: EdgeInsets.all(10.r),
      backgroundColor: const Color(0xFFF7F9FB),
      borderRadius: AppRadius.radius20.r,
      border: Border.all(color: theme.colorScheme.outlineVariant, width: .7.w),
      boxShadow: const [],
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Bone(
                  width: 100.w,
                  height: 16.h,
                  borderRadius: BorderRadius.circular(AppRadius.radius4.r),
                ),

                Gap(AppSpacing.space8.h),

                Bone(
                  width: 190.w,
                  height: 14.h,
                  borderRadius: BorderRadius.circular(AppRadius.radius4.r),
                ),
              ],
            ),
          ),

          Gap(AppSpacing.space8.w),

          Bone(
            width: 85.w,
            height: 30.h,
            borderRadius: BorderRadius.circular(AppRadius.radius16.r),
          ),
        ],
      ),
    );
  }
}
