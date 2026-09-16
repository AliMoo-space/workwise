import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:workwise/core/design_system/spacing/app_radius.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';

class MonthlyPerformance extends StatelessWidget {
  const MonthlyPerformance({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      height: 180.h,
      width: double.infinity.w,
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      backgroundColor: Theme.of(context).colorScheme.outline,
      borderRadius: AppRadius.radius20.r,
      border: Border.all(color: Colors.transparent, width: 0),
      boxShadow: const [],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                context.l10n.thisMonth,
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              Gap(AppSpacing.space4.h),

              AppText(
                context.l10n.yourPerformance,
                style: Theme.of(context).textTheme.titleMedium,
              ),

              Gap(AppSpacing.space4.h),

              AppText(
                "5% ${context.l10n.fromLastMonth}",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),

          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularPercentIndicator(
                radius: 50.0.r,
                lineWidth: 10.0.w,
                percent: 0.87,
                animation: true,
                animationDuration: 1200,
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText(
                      "87%",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),

                    Gap(AppSpacing.space4.h),

                    AppText(
                      context.l10n.overall,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                progressColor: Theme.of(context).colorScheme.secondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
