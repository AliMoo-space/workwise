import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';

class RequestLeaveTitle extends StatelessWidget {
  const RequestLeaveTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentGeometry.centerLeft,
      child: Text(
        "Request leave",
        style: TextStyle(
          color: AppColors.black,
          fontSize: 20.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
