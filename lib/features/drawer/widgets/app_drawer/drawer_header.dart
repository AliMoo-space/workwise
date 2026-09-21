import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';

import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_text_styles.dart';

class DrawerHeader extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String? avatarUrl;

  const DrawerHeader({
    super.key,
    required this.userName,
    required this.userEmail,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.space24.r),
      decoration: const BoxDecoration(color: AppColors.primary),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 36.r,
              backgroundColor: AppColors.secondary,
              backgroundImage: avatarUrl != null
                  ? NetworkImage(avatarUrl!)
                  : null,
              child: avatarUrl == null
                  ? AppText(
                      _getInitials(userName),
                      style: AppTextStyles.titleLarge.copyWith(
                        color: AppColors.onPrimary,
                      ),
                    )
                  : null,
            ),

            Gap(16.h),

            AppText(
              userName,
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.onPrimary,
              ),
            ),

            Gap(4.h),

            AppText(
              userEmail,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.onPrimary.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');

    if (parts.isEmpty || parts.first.isEmpty) {
      return '';
    }

    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}
