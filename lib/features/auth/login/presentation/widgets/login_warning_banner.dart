import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
// import 'package:workwise/core/design_system/colors/app_colors.dart';

class LoginWarningBanner extends StatelessWidget {
  final String message;
  final bool isSessionExpired;

  const LoginWarningBanner({
    super.key,
    required this.message,
    this.isSessionExpired = false,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isSessionExpired
        ? Theme.of(context).colorScheme.onError // بني/أصفر داكن لانتهاء الجلسة
        : Theme.of(context).colorScheme.error; // أحمر داكن للخطأ

    final borderColor = isSessionExpired
        ? Theme.of(context).colorScheme.onError
        : Theme.of(context).colorScheme.error;

    final iconColor = isSessionExpired ? Theme.of(context).colorScheme.onError : Theme.of(context).colorScheme.error;

    return Container(
      width: double.infinity,
      padding:  EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: borderColor, width: 1.w),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: iconColor, size: 20.sp),
          Gap( 10.w),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: iconColor,
                fontSize: 13.sp,
                height: 1.3.h,
              ),
            ),
          ),
        ],
      ),
    );
  }
}