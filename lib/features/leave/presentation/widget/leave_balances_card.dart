import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';

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
            color: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.r),
              side: BorderSide(color: AppColors.border, width: 1.w),
            ),
            child: Padding(
              padding: EdgeInsets.all(12.r),
              child: Column(
                children: [
                  Align(
                    alignment: AlignmentGeometry.topLeft,
                    child: Text(
                      "Annual",
                      style: TextStyle(color: AppColors.black, fontSize: 15.sp),
                    ),
                  ),
                  Gap(10.h),
                  Row(
                    children: [
                      Text(
                        "13",
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "/21",
                        style: TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: AlignmentGeometry.topLeft,
                    child: Text("days left"),
                  ),
                  Gap(10.h),
                  LinearProgressIndicator(
                    value: 13 / 21,
                    backgroundColor: Colors.grey.shade300,
                    color: AppColors.success,
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
            color: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.r),
              side: BorderSide(color: AppColors.border, width: 1.w),
            ),
            child: Padding(
              padding: EdgeInsets.all(12.r),
              child: Column(
                children: [
                  Align(
                    alignment: AlignmentGeometry.topLeft,
                    child: Text(
                      "Casual",
                      style: TextStyle(color: AppColors.black, fontSize: 15.sp),
                    ),
                  ),
                  Gap(10.h),
                  Row(
                    children: [
                      Text(
                        "4",
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "/7",
                        style: TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: AlignmentGeometry.topLeft,
                    child: Text("days left"),
                  ),
                  Gap(10.h),
                  LinearProgressIndicator(
                    value: 13 / 25,
                    backgroundColor: Colors.grey.shade300,
                    color: AppColors.success,
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
            color: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.r),
              side: BorderSide(color: AppColors.border, width: 1.w),
            ),
            child: Padding(
              padding: EdgeInsets.all(12.r),
              child: Column(
                children: [
                  Align(
                    alignment: AlignmentGeometry.topLeft,
                    child: Text(
                      "Sick",
                      style: TextStyle(color: AppColors.black, fontSize: 15.sp),
                    ),
                  ),
                  Gap(10.h),
                  Row(
                    children: [
                      Text(
                        "8",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "/10",
                        style: TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: AlignmentGeometry.topLeft,
                    child: Text("days left"),
                  ),
                  Gap(10.h),
                  LinearProgressIndicator(
                    value: 13 / 17,
                    backgroundColor: Colors.grey.shade300,
                    color: AppColors.success,
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
