import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';

import 'package:workwise/core/design_system/spacing/app_radius.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/layout/app_divider.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';

class ActionPlanCard extends StatelessWidget {
  const ActionPlanCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      height: 265.h,
      width: double.infinity.w,
      padding: EdgeInsets.zero,
      backgroundColor: Theme.of(context).colorScheme.onError,
      borderRadius: AppRadius.radius24.r,
      border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      boxShadow: const [],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Gap(AppSpacing.space8.h),
            Row(
              children: [
                Gap(AppSpacing.space20.w),
                const Icon(Icons.format_list_numbered),
                Gap(AppSpacing.space4.w),
                AppText(
                  "Prioritized next steps",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),

            Gap(AppSpacing.space8.h),

            AppDivider(color: Theme.of(context).colorScheme.outlineVariant),

            Gap(AppSpacing.space8.h),

            Padding(
              padding: EdgeInsets.all(AppSpacing.space4.r),
              child: Row(
                children: [
                  Container(
                    height: 35.h,
                    width: 35.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        AppRadius.radiusFull.r,
                      ),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: Center(
                      child: AppText(
                        "1",
                        color: Theme.of(context).colorScheme.onError,
                      ),
                    ),
                  ),
                  Gap(AppSpacing.space8.w),

                  const AppText("Complete Advanced\n SQL certification"),

                  const Spacer(),

                  Container(
                    height: 25.h,
                    width: 80.w,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(AppRadius.radius16.r),
                    ),
                    child: const Center(child: AppText("Aug 2026")),
                  ),
                ],
              ),
            ),

            Gap(AppSpacing.space8.h),

            AppDivider(color: Theme.of(context).colorScheme.outlineVariant),

            Gap(AppSpacing.space8.h),

            Padding(
              padding: EdgeInsets.all(AppSpacing.space4.r),
              child: Row(
                children: [
                  Container(
                    height: 35.h,
                    width: 35.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        AppRadius.radiusFull.r,
                      ),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: Center(
                      child: AppText(
                        "2",
                        color: Theme.of(context).colorScheme.onError,
                      ),
                    ),
                  ),

                  Gap(AppSpacing.space8.w),

                  const AppText(
                    "Delegate one recurring\n report to a junior analyst",
                  ),

                  const Spacer(),

                  Container(
                    height: 25.h,
                    width: 80.w,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(AppRadius.radius16.r),
                    ),
                    child: const Center(child: AppText("Aug 2026")),
                  ),
                ],
              ),
            ),

            Gap(AppSpacing.space8.h),

            AppDivider(color: Theme.of(context).colorScheme.outlineVariant),

            Gap(AppSpacing.space8.h),

            Padding(
              padding: EdgeInsets.all(AppSpacing.space4.r),
              child: Row(
                children: [
                  Container(
                    height: 35.h,
                    width: 35.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        AppRadius.radiusFull.r,
                      ),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: Center(
                      child: AppText(
                        "3",
                        color: Theme.of(context).colorScheme.onError,
                      ),
                    ),
                  ),

                  Gap(AppSpacing.space8.w),

                  const AppText("Complete Advanced\n SQL certification"),

                  const Spacer(),

                  Container(
                    height: 25.h,
                    width: 80.w,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(AppRadius.radius16.r),
                    ),
                    child: const Center(child: AppText("Aug 2026")),
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
