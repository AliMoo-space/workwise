import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';

class LeaveTitle extends StatelessWidget {
  const LeaveTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        "Leave",
        style: TextStyle(
          color: AppColors.black,
          fontSize: 25.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
