import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';

class PerformanceOverview extends StatelessWidget {
  const PerformanceOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 100.h,
          width: 110.w,
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border.all(width: .5.w, color: AppColors.border),
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "92%",
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 23.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text("Tasks", style: TextStyle(fontSize: 14.sp)),
            ],
          ),
        ),

        Container(
          height: 100.h,
          width: 110.w,
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border.all(width: .5.w, color: AppColors.border),
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "88%",
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 23.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text("Quality", style: TextStyle(fontSize: 14.sp)),
            ],
          ),
        ),

        Container(
          height: 100.h,
          width: 110.w,
          padding: EdgeInsets.symmetric(horizontal: 15.r),
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border.all(width: .5.w, color: AppColors.border),
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "95%",
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 23.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text("Attendance", style: TextStyle(fontSize: 14.sp)),
            ],
          ),
        ),
      ],
    );
  }
}
