import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/spacing/app_radius.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';

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
    final theme = Theme.of(context);
    final backgroundColor = isSessionExpired
        ? theme.colorScheme.onError
        : theme.colorScheme.error;

    final borderColor = isSessionExpired
        ? theme.colorScheme.onError
        : theme.colorScheme.error;

    final iconColor = isSessionExpired
        ? theme.colorScheme.onError
        : theme.colorScheme.error;

    return AppCard(
      width: double.infinity,
      backgroundColor: backgroundColor,
      borderRadius: AppRadius.radius12,
      border: Border.all(color: borderColor, width: 1.w),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.space16,
        vertical: AppSpacing.space12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: iconColor, size: 20.sp),
          Gap(AppSpacing.space12),
          Expanded(
            child: AppText(
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
