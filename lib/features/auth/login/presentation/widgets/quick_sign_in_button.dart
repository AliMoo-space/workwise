import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:workwise/generated/app_localizations.dart';

class QuickSignInButton extends StatelessWidget {
  final VoidCallback onTap;

  const QuickSignInButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
            final localization = AppLocalizations.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          // color: AppColors.surface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Theme.of(context).colorScheme.primary),
        ),
        child: Row(
          children: [
            Icon(
              Icons.fingerprint,
              color: Theme.of(context).colorScheme.primary,
              size: 28.sp,
            ),
            Gap(14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localization.quickSignIn,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gap(2.h),
                  Text(
                    localization.useFingerprintOrFaceId,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
