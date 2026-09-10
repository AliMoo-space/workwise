import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';

class MonthlyPerformance extends StatelessWidget {
  const MonthlyPerformance({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.h,
      width: double.infinity.w,
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      decoration: BoxDecoration(
        color: AppColors.border,
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
              Text("THIS MONTH", style: TextStyle(fontSize: 14.sp)),
              Gap(5.h),
              Text(
                "Your performance",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              Gap(5.h),
              Text("5% from last month", style: TextStyle(fontSize: 14.sp)),
            ],
          ),

          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularPercentIndicator(
                radius: 70.0.r,
                lineWidth: 10.0.w,
                percent: 0.87,
                animation: true,
                animationDuration: 1200,
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "87%",
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    Gap(4.h),
                    Text(
                      "overall",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                progressColor: AppColors.secondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
