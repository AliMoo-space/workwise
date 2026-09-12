import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';

class LeaveBalancesCard extends StatelessWidget {
  const LeaveBalancesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: 150.h,
          width: 110.w,
          child: Card(
            // color: AppColors.white,
            color: Theme.of(context).colorScheme.onError,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.r),
              side: BorderSide(
                color: Theme.of(context).colorScheme.outline,
                width: 1.w,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(12.r),
              child: Column(
                children: [
                  Align(
                    alignment: AlignmentGeometry.topLeft,
                    child: Text(
                      "Annual",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  Gap(10.h),
                  Row(
                    children: [
                      Text(
                        "13",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Text(
                        "/21",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ],
                  ),
                  Align(
                    alignment: AlignmentGeometry.topLeft,
                    child: Text(
                      "days left",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  Gap(10.h),
                  LinearProgressIndicator(
                    value: 13 / 21,
                    backgroundColor: Theme.of(context).colorScheme.outline,

                    color: Theme.of(context).colorScheme.tertiary,

                    minHeight: 8.0.h,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 150.h,
          width: 110.w,
          child: Card(
            // color: AppColors.white,
            color: Theme.of(context).colorScheme.onError,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.r),
              side: BorderSide(
                color: Theme.of(context).colorScheme.outline,
                width: 1.w,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(12.r),
              child: Column(
                children: [
                  Align(
                    alignment: AlignmentGeometry.topLeft,
                    child: Text(
                      "Casual",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  Gap(10.h),
                  Row(
                    children: [
                      Text(
                        "4",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Text("/7", style: Theme.of(context).textTheme.labelLarge),
                    ],
                  ),
                  Align(
                    alignment: AlignmentGeometry.topLeft,
                    child: Text(
                      "days left",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  Gap(10.h),
                  LinearProgressIndicator(
                    value: 13 / 25,
                    // backgroundColor: Colors.grey.shade300,
                    backgroundColor: Theme.of(context).colorScheme.outline,

                    color: Theme.of(context).colorScheme.tertiary,
                    minHeight: 8.0.h,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 150.h,
          width: 110.w,
          child: Card(
            // color: AppColors.white,
            color: Theme.of(context).colorScheme.onError,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.r),
              side: BorderSide(
                color: Theme.of(context).colorScheme.outline,
                width: 1.w,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(12.r),
              child: Column(
                children: [
                  Align(
                    alignment: AlignmentGeometry.topLeft,
                    child: Text(
                      "Sick",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  Gap(10.h),
                  Row(
                    children: [
                      Text(
                        "8",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Text(
                        "/10",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ],
                  ),
                  Align(
                    alignment: AlignmentGeometry.topLeft,
                    child: Text(
                      "days left",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  Gap(10.h),
                  LinearProgressIndicator(
                    value: 13 / 17,

                    backgroundColor: Theme.of(context).colorScheme.outline,
                    color: Theme.of(context).colorScheme.tertiary,

                    minHeight: 8.0.h,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
