import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';

class PersonalGoalsList extends StatelessWidget {
  const PersonalGoalsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        return SizedBox(
          height: 120.h,
          width: double.infinity.w,
          child: Card(
            color: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
              side: BorderSide(color: AppColors.border, width: .7.w),
            ),
            child: Padding(
              padding: EdgeInsets.all(10.r),
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Complete Advanced\n SQL certification",
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                          ),
                          Text("Target: Aug 2026"),
                        ],
                      ),

                      Spacer(),

                      Container(
                        width: 100.w,
                        height: 35.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.r),
                          color: AppColors.border,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 8.h,
                              width: 8.w,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                            ),

                            Gap(10.w),

                            const Text(
                              "On\nTrack",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Gap(15.h),
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: 13 / 25.r,
                          backgroundColor: AppColors.border,
                          color: AppColors.primary,
                          minHeight: 8.h,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "50%",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
