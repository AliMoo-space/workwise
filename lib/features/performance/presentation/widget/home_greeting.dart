import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';

class HomeGreeting extends StatelessWidget {
  const HomeGreeting({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        "Good morning, Alex",
        style: TextStyle(
          fontSize: 20.sp,
          color: AppColors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
