import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:workwise/generated/app_localizations.dart';

class MonthlyPerformance extends StatelessWidget {
  const MonthlyPerformance({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Container(
      height: 180.h,
      width: double.infinity.w,
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.outline,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localization.thisMonth,
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              Gap(5.h),

              Text(
                localization.yourPerformance,
                style: Theme.of(context).textTheme.titleMedium,
              ),

              Gap(5.h),

              Text(
                "5% ${localization.fromLastMonth}",
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
                    Text(
                      "87%",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),

                    Gap(4.h),

                    Text(
                      localization.overall,
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
