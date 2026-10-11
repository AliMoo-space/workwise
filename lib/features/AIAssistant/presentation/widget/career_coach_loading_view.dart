import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:workwise/core/design_system/spacing/app_radius.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';

class CareerCoachShimmer extends StatelessWidget {
  const CareerCoachShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Skeletonizer(
        enabled: true,
        effect: const ShimmerEffect(
          baseColor: Color(0xFFF0F3F5),
          highlightColor: Color(0xFFFAFBFC),
          duration: Duration(milliseconds: 1700),
        ),
        child: Column(
          children: [
            // Strengths
            _buildSectionTitle(),

            const Gap(AppSpacing.space12),

            _buildStrengthCard(),
            const Gap(AppSpacing.space12),

            _buildStrengthCard(),
            const Gap(AppSpacing.space12),

            // Development Areas
            _buildSectionTitle(),

            const Gap(AppSpacing.space12),

            _buildDevelopmentAreaCard(),
            const Gap(AppSpacing.space12),

            _buildDevelopmentAreaCard(),

            const Gap(AppSpacing.space20),

            // Action Plan
            _buildSectionTitle(),

            const Gap(AppSpacing.space12),

            _buildActionPlanCard(),
            const Gap(AppSpacing.space12),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle() {
    return Row(
      children: [
        Bone(
          width: 24.w,
          height: 24.h,
          borderRadius: BorderRadius.circular(AppRadius.radius8.r),
        ),
        Gap(AppSpacing.space8.w),
        Bone(
          width: 140.w,
          height: 20.h,
          borderRadius: BorderRadius.circular(AppRadius.radius8.r),
        ),
      ],
    );
  }

  Widget _buildStrengthCard() {
    return AppCard(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.space16.r),
      backgroundColor: Colors.white,
      borderRadius: AppRadius.radius20.r,
      border: Border.all(color: const Color(0xFFD9E2EC)),
      boxShadow: const [],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Bone(
            width: 130.w,
            height: 18.h,
            borderRadius: BorderRadius.circular(AppRadius.radius8.r),
          ),

          Gap(AppSpacing.space8.h),

          Bone(
            width: double.infinity,
            height: 14.h,
            borderRadius: BorderRadius.circular(AppRadius.radius4.r),
          ),

          Gap(AppSpacing.space8.h),

          Bone(
            width: 240.w,
            height: 14.h,
            borderRadius: BorderRadius.circular(AppRadius.radius4.r),
          ),
        ],
      ),
    );
  }

  Widget _buildDevelopmentAreaCard() {
    return AppCard(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.space16.r),
      backgroundColor: Colors.white,
      borderRadius: AppRadius.radius20.r,
      border: Border.all(color: const Color(0xFFD9E2EC)),
      boxShadow: const [],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Bone(
                width: 40.w,
                height: 40.w,
                borderRadius: BorderRadius.circular(AppRadius.radius12.r),
              ),

              Gap(AppSpacing.space12.w),

              Expanded(
                child: Bone(
                  height: 18.h,
                  borderRadius: BorderRadius.circular(AppRadius.radius4.r),
                ),
              ),
            ],
          ),

          Gap(AppSpacing.space12.h),

          Bone(
            width: double.infinity,
            height: 14.h,
            borderRadius: BorderRadius.circular(AppRadius.radius4.r),
          ),

          Gap(AppSpacing.space8.h),

          Bone(
            width: 200.w,
            height: 14.h,
            borderRadius: BorderRadius.circular(AppRadius.radius4.r),
          ),
        ],
      ),
    );
  }

  Widget _buildActionPlanCard() {
    return AppCard(
      width: double.infinity,
      height: 90.h,
      padding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      borderRadius: AppRadius.radius24.r,
      border: Border.all(color: const Color(0xFFD9E2EC)),
      boxShadow: const [],
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.space8.r),
        child: Row(
          children: [
            Bone(
              width: 34.w,
              height: 34.h,
              borderRadius: BorderRadius.circular(AppRadius.radiusFull.r),
            ),

            Gap(AppSpacing.space8.w),

            Expanded(
              child: Bone(
                height: 16.h,
                borderRadius: BorderRadius.circular(AppRadius.radius4.r),
              ),
            ),

            Gap(AppSpacing.space8.w),

            Bone(
              width: 60.w,
              height: 25.h,
              borderRadius: BorderRadius.circular(AppRadius.radius16.r),
            ),
          ],
        ),
      ),
    );
  }
}
