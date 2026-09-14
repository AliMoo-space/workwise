import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';
import 'package:workwise/generated/app_localizations.dart';

class FingerprintHeaderWidget extends StatelessWidget {
  const FingerprintHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
        final localization = AppLocalizations.of(context);

    return Column(
      children: [
        Container(
          width: double.infinity,
          color: AppColors.primary,
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Center(
            child: Image.asset(
              'assets/images/logo2.jpeg',
              height: 150.h,
              width: 150.w,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          color: AppColors.background,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Gap(26.h),

              Text(
               localization.welcomeBack ,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
               localization.verifyYourIdentityToAccessYourAccount ,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
