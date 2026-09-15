import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';

class StrengthCard extends StatelessWidget {
  const StrengthCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170.h,
      width: double.infinity.w,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onError,
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(15.r),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Data storytelling",
                  style: Theme.of(context).textTheme.titleSmall,
                ),

                Spacer(),

                Container(
                  width: 100.w,
                  height: 25.w,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiary,
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Center(
                    child: Text(
                      "Strength",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onError,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Gap(15.h),

            Container(
              height: 90.h,
              width: double.infinity.w,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(15.r),
                child: Text(
                  "“The Q1 report translated complex churn data into a plan leadership acted on the same week.” — Manager review",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
