import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';

import 'package:workwise/core/design_system/spacing/app_radius.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';

class StrengthCard extends StatelessWidget {
  const StrengthCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      height: 170.h,
      width: double.infinity.w,
      padding: EdgeInsets.all(AppSpacing.space16.r),
      backgroundColor: Theme.of(context).colorScheme.onError,
      borderRadius: AppRadius.radius16.r,
      border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      boxShadow: const [],
      child: Column(
        children: [
          Row(
            children: [
              AppText(
                "Data storytelling",
                style: Theme.of(context).textTheme.titleSmall,
                textAlign: TextAlign.start,
              ),

              const Spacer(),

              Container(
                width: 100.w,
                height: 25.h,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(AppRadius.radius16.r),
                ),
                child: Center(
                  child: AppText(
                    "Strength",
                    color: Theme.of(context).colorScheme.onError,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),

          Gap(AppSpacing.space16.h),

          AppCard(
            height: 90.h,
            width: double.infinity.w,
            padding: EdgeInsets.all(AppSpacing.space16.r),
            backgroundColor: Theme.of(context).colorScheme.outlineVariant,
            borderRadius: AppRadius.radius16.r,
            border: Border.all(color: Colors.transparent, width: 0),
            boxShadow: const [],
            child: const AppText(
              "“The Q1 report translated complex churn data into a plan leadership acted on the same week.” — Manager review",
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}
