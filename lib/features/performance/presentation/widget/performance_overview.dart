import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:workwise/generated/app_localizations.dart';

class PerformanceOverview extends StatelessWidget {
  const PerformanceOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 100.h,
          width: 110.w,
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          decoration: BoxDecoration(
            border: Border.all(width: .5.w),
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("92%", style: Theme.of(context).textTheme.headlineMedium),
              Text(
                localization.tasks,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),

        Container(
          height: 100.h,
          width: 110.w,
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          decoration: BoxDecoration(
            border: Border.all(width: .5.w),
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("88%", style: Theme.of(context).textTheme.headlineMedium),
              Text(
                localization.quality,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),

        Container(
          height: 100.h,
          width: 110.w,
          padding: EdgeInsets.symmetric(horizontal: 15.r),
          decoration: BoxDecoration(
            border: Border.all(width: .5.w),
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("95%", style: Theme.of(context).textTheme.headlineMedium),
              Text(
                localization.attendance,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
