import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';

class DevelopmentAreaCard extends StatelessWidget {
  const DevelopmentAreaCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130.h,
      width: double.infinity.w,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onError,
        borderRadius: BorderRadius.circular(30.r),

        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Padding(
        padding: EdgeInsets.all(15.r),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 35.h,
                  width: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.r),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: Center(child: Icon(Icons.trending_up)),
                ),
                Gap(10.h),
                Text(
                  "Delegation",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),

            Gap(5.h),

            Text(
              "Tends to absorb execution work that could be shared to build team capacity.",
            ),
          ],
        ),
      ),
    );
  }
}
