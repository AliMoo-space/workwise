import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';

class ActionPlanCard extends StatelessWidget {
  const ActionPlanCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270.h,
      width: double.infinity.w,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onError,
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 15.h),
            child: Row(
              children: [
                Gap(20.w),
                Icon(Icons.format_list_numbered),
                Gap(5.w),
                Text(
                  "Prioritized next steps",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          ),

          Gap(10.h),

          Divider(
            color: Theme.of(context).colorScheme.outline,
            thickness: 1,
            height: 1,
          ),

          Gap(10.h),

          Padding(
            padding: EdgeInsets.all(5.r),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 35.h,
                  width: 35.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.r),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: Center(
                    child: Text(
                      "1",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onError,
                      ),
                    ),
                  ),
                ),
                Gap(10.w),
                Text("Complete Advanced\n SQL certification"),
                Spacer(),
                Container(
                  height: 25.h,
                  width: 80.w,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outline,
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Center(child: Text("Aug 2026")),
                ),
              ],
            ),
          ),

          Gap(10.h),

          Divider(
            color: Theme.of(context).colorScheme.outline,
            thickness: 1,
            height: 1,
          ),

          Gap(10.h),

          Padding(
            padding: EdgeInsets.all(5.r),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 35.h,
                  width: 35.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.r),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: Center(
                    child: Text(
                      "2",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onError,
                      ),
                    ),
                  ),
                ),
                Gap(10.w),
                Text("Delegate one recurring\n report to a junior analyst"),
                Spacer(),
                Container(
                  height: 25.h,
                  width: 80.w,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outline,
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Center(child: Text("Aug 2026")),
                ),
              ],
            ),
          ),

          Gap(10.h),

          Divider(
            color: Theme.of(context).colorScheme.outline,
            thickness: 1,
            height: 1,
          ),

          Gap(10.h),

          Padding(
            padding: EdgeInsets.all(5.r),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 35.h,
                  width: 35.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.r),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: Center(
                    child: Text(
                      "3",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onError,
                      ),
                    ),
                  ),
                ),
                Gap(10.w),
                Text("Complete Advanced\n SQL certification"),
                Spacer(),
                Container(
                  height: 25.h,
                  width: 80.w,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outline,
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Center(child: Text("Aug 2026")),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
