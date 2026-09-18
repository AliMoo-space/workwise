import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import 'package:workwise/core/design_system/colors/app_colors.dart';
import 'package:workwise/core/design_system/typography/app_text_styles.dart';
import 'package:workwise/core/design_system/widgets/media/app_network_image.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppNetworkImage(
      imageUrl: 'https://via.placeholder.com/120',
      width: 80.w,
      height: 80.h,
      shape: BoxShape.circle,
      fit: BoxFit.cover,
      backgroundColor: AppColors.surfaceContainer,
      errorWidget: _buildFallback(),
    );
  }

  Widget _buildFallback() {
    return Container(
      width: 80.w,
      height: 80.h,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surfaceContainer,
      ),
      alignment: Alignment.center,
      child: AppText(
        'OH',
        style: AppTextStyles.titleLarge,
        color: AppColors.textPrimary,
      ),
    );
  }
}