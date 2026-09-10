import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';

class LeaveHistoryList extends StatelessWidget {
  const LeaveHistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: SizedBox(
            height: 80.h,
            width: double.infinity,
            child: Card(
              color: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
                side: BorderSide(color: AppColors.border, width: .7.w),
              ),
              child: Padding(
                padding: EdgeInsets.all(10.r),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Annual Leave",
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "May 20 – May 24 · 5 days",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    Container(
                      width: 110.w,
                      height: 30.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppColors.border,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 10.h,
                            width: 10.w,
                            decoration: BoxDecoration(
                              color: AppColors.success,
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                          ),
                          Gap(10.w),
                          Text(
                            "Approved",
                            style: TextStyle(
                              color: AppColors.success,
                              fontSize: 15.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
