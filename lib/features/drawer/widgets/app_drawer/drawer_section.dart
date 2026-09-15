import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_text_styles.dart';

class DrawerSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const DrawerSection({super.key, this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.space24.h,
              vertical: AppSpacing.space8.w,
            ),
            child: Text(
              title!,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textSecondary,
                letterSpacing: 0.5.r,
              ),
            ),
          ),
        ],
        ...children,
        Gap(8.h),
      ],
    );
  }
}
