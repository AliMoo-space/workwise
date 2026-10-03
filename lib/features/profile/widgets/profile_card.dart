import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/typography/app_text_styles.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/media/app_network_image.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/features/profile/domain/entities/profile.dart';

import 'employee_info.dart';
import 'profile_status_badge.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.profile,
    required this.onChangeAvatar,
    this.avatarPreview,
    this.isUpdatingAvatar = false,
  });

  final Profile profile;
  final VoidCallback onChangeAvatar;
  final Uint8List? avatarPreview;
  final bool isUpdatingAvatar;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.all(AppSpacing.space16.r),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 80.w,
                height: 80.h,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: avatarPreview != null
                          ? ClipOval(
                              child: Image.memory(
                                avatarPreview!,
                                width: 80.w,
                                height: 80.h,
                                fit: BoxFit.cover,
                              ),
                            )
                          : profile.avatarUrl.isEmpty
                              ? _buildAvatarFallback(profile.name)
                              : AppNetworkImage(
                                  imageUrl: profile.avatarUrl,
                                  width: 80.w,
                                  height: 80.h,
                                  shape: BoxShape.circle,
                                  fit: BoxFit.cover,
                                  backgroundColor: AppColors.surfaceContainer,
                                  errorWidget: _buildAvatarFallback(
                                    profile.name,
                                  ),
                                ),
                    ),
                    PositionedDirectional(
                      end: 0,
                      bottom: 0,
                      child: Material(
                        color: AppColors.primary,
                        shape: const CircleBorder(),
                        child: IconButton(
                          tooltip: 'Change profile photo',
                          onPressed: isUpdatingAvatar ? null : onChangeAvatar,
                          constraints: BoxConstraints.tightFor(
                            width: 30.w,
                            height: 30.h,
                          ),
                          padding: EdgeInsets.zero,
                          icon: isUpdatingAvatar
                              ? SizedBox(
                                  width: 15.w,
                                  height: 15.h,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Icon(
                                  Icons.camera_alt_outlined,
                                  size: 16.sp,
                                  color: Colors.white,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Gap(AppSpacing.space16.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(profile.name, style: AppTextStyles.headlineMedium),

                    Gap(AppSpacing.space4.h),

                    AppText(
                      profile.jobTitle,
                      style: AppTextStyles.bodyMedium,
                      color: AppColors.textSecondary,
                    ),

                    Gap(AppSpacing.space2.h),

                    AppText(
                      profile.departmentName ?? profile.roleLabel,
                      style: AppTextStyles.bodySmall,
                      color: AppColors.textSecondary,
                    ),

                    Gap(AppSpacing.space8.h),

                    ProfileStatusBadge(
                      text: [
                        profile.status,
                        profile.employmentType,
                      ].where((value) => value.isNotEmpty).join(' · '),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Gap(AppSpacing.space16.h),

          EmployeeInfo(profile: profile),
        ],
      ),
    );
  }

  Widget _buildAvatarFallback(String name) {
    final initials = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0])
        .join()
        .toUpperCase();

    return Container(
      width: 72.w,
      height: 72.h,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surfaceContainer,
      ),
      alignment: Alignment.center,
      child: AppText(
        initials.isEmpty ? '?' : initials,
        style: AppTextStyles.titleLarge,
        color: AppColors.textPrimary,
      ),
    );
  }
}
