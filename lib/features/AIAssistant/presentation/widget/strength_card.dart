import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';

import 'package:workwise/core/design_system/spacing/app_radius.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/features/AIAssistant/domain/entities/career_coach.dart';

class StrengthCard extends StatelessWidget {
  const StrengthCard({super.key, required this.strength});

  final Strength strength;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      height: 130.h,
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
                strength.title,
                style: Theme.of(context).textTheme.titleSmall,
                textAlign: TextAlign.start,
              ),

              const Spacer(),

              // Container(
              //   width: 100.w,
              //   height: 25.h,
              //   decoration: BoxDecoration(
              //     color: Theme.of(context).colorScheme.tertiary,
              //     borderRadius: BorderRadius.circular(AppRadius.radius16.r),
              //   ),
              //   child: Center(
              //     child: AppText(
              //       "Strength",
              //       color: Theme.of(context).colorScheme.onError,
              //       textAlign: TextAlign.center,
              //     ),
              //   ),
              // ),
            ],
          ),

          Gap(AppSpacing.space8.h),

          AppCard(
            height: 65.h,
            width: double.infinity.w,
            padding: EdgeInsets.all(AppSpacing.space16.r),
            backgroundColor: Theme.of(context).colorScheme.outlineVariant,
            borderRadius: AppRadius.radius16.r,
            border: Border.all(color: Colors.transparent, width: 0),
            boxShadow: const [],
            child: AppText(
              strength.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}
