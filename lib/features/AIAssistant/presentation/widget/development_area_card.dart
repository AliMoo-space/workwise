import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';

import 'package:workwise/core/design_system/spacing/app_radius.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';

class DevelopmentAreaCard extends StatelessWidget {
  const DevelopmentAreaCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      height: 130.h,
      width: double.infinity.w,
      padding: EdgeInsets.all(AppSpacing.space16.r),
      backgroundColor: Theme.of(context).colorScheme.onError,
      borderRadius: AppRadius.radius32.r,
      border: Border.all(color: Theme.of(context).colorScheme.outline),
      boxShadow: const [],
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 35.h,
                width: 35.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.radiusFull.r),
                  color: Theme.of(context).colorScheme.surface,
                ),
                child: const Center(child: Icon(Icons.trending_up)),
              ),

              Gap(AppSpacing.space8.w),

              AppText(
                "Delegation",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),

          Gap(AppSpacing.space4.h),

          const AppText(
            "Tends to absorb execution work that could be shared to build team capacity.",
          ),
        ],
      ),
    );
  }
}
