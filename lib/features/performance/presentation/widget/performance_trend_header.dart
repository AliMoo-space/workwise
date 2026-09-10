import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';

class PerformanceTrendHeader extends StatelessWidget {
  const PerformanceTrendHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Align(
          alignment: AlignmentGeometry.topLeft,
          child: Text(
            "Performance trend",
            style: TextStyle(
              fontSize: 18.sp,
              color: AppColors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Spacer(),
      ],
    );
  }
}
