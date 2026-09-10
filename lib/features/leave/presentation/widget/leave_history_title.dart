import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';

class LeaveHistoryTitle extends StatelessWidget {
  const LeaveHistoryTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Leave history",
          style: TextStyle(
            color: AppColors.black,
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
          ),
        ),

        Spacer(),

        TextButton(
          onPressed: () {},
          child: Text(
            "view",
            style: TextStyle(
              color: AppColors.black,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
