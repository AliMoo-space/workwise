import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/spacing/app_radius.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';

class LeaveBalancesCard extends StatelessWidget {
  const LeaveBalancesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppCard(
          height: 150.h,
          width: 110.w,
          padding: EdgeInsets.all(AppRadius.radius12.r),
          backgroundColor: Theme.of(context).colorScheme.onError,
          borderRadius: AppRadius.radius32.r,
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
            width: 1.w,
          ),
          boxShadow: const [],
          child: Column(
            children: [
              Align(
                alignment: AlignmentGeometry.topLeft,
                child: AppText(
                  "Annual",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),

              Gap(AppSpacing.space12.h),

              Row(
                children: [
                  AppText(
                    "13",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  AppText("/21", style: Theme.of(context).textTheme.labelLarge),
                ],
              ),

              Align(
                alignment: AlignmentGeometry.topLeft,
                child: AppText(
                  "days left",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),

              Gap(AppSpacing.space12.h),

              LinearProgressIndicator(
                value: 13 / 21,
                backgroundColor: Theme.of(context).colorScheme.outline,
                color: Theme.of(context).colorScheme.tertiary,
                minHeight: 8.0.h,
                borderRadius: BorderRadius.circular(AppRadius.radius12.r),
              ),
            ],
          ),
        ),

        AppCard(
          height: 150.h,
          width: 110.w,
          padding: EdgeInsets.all(AppRadius.radius12.r),
          backgroundColor: Theme.of(context).colorScheme.onError,
          borderRadius: AppRadius.radius32.r,
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
            width: 1.w,
          ),
          boxShadow: const [],
          child: Column(
            children: [
              Align(
                alignment: AlignmentGeometry.topLeft,
                child: AppText(
                  "Casual",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),

              Gap(AppSpacing.space12.h),

              Row(
                children: [
                  AppText(
                    "4",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  AppText("/7", style: Theme.of(context).textTheme.labelLarge),
                ],
              ),

              Align(
                alignment: AlignmentGeometry.topLeft,
                child: AppText(
                  "days left",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),

              Gap(AppSpacing.space12.h),

              LinearProgressIndicator(
                value: 13 / 25,
                backgroundColor: Theme.of(context).colorScheme.outline,
                color: Theme.of(context).colorScheme.tertiary,
                minHeight: 8.0.h,
                borderRadius: BorderRadius.circular(AppRadius.radius12.r),
              ),
            ],
          ),
        ),

        AppCard(
          height: 150.h,
          width: 110.w,
          padding: EdgeInsets.all(AppRadius.radius12.r),
          backgroundColor: Theme.of(context).colorScheme.onError,
          borderRadius: AppRadius.radius32.r,
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
            width: 1.w,
          ),
          boxShadow: const [],
          child: Column(
            children: [
              Align(
                alignment: AlignmentGeometry.topLeft,
                child: AppText(
                  "Sick",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),

              Gap(AppSpacing.space12.h),

              Row(
                children: [
                  AppText(
                    "8",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  AppText("/10", style: Theme.of(context).textTheme.labelLarge),
                ],
              ),

              Align(
                alignment: AlignmentGeometry.topLeft,
                child: AppText(
                  "days left",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),

              Gap(AppSpacing.space12.h),

              LinearProgressIndicator(
                value: 13 / 17,
                backgroundColor: Theme.of(context).colorScheme.outline,
                color: Theme.of(context).colorScheme.tertiary,
                minHeight: 8.0.h,
                borderRadius: BorderRadius.circular(AppRadius.radius12.r),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
