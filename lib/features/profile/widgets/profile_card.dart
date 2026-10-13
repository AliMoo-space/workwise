import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/typography/app_text_styles.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/media/profile_photo_viewer.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/services/service_locator.dart';
import 'package:workwise/features/profile/domain/entities/profile.dart';

import 'employee_info.dart';
import 'profile_status_badge.dart';

class ProfileCard extends StatefulWidget {
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
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  Future<Uint8List?>? _avatarFuture;

  @override
  void initState() {
    super.initState();
    _loadAvatar();
  }

  @override
  void didUpdateWidget(covariant ProfileCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.profile.avatarUrl != widget.profile.avatarUrl) {
      _loadAvatar();
    }
  }

  void _loadAvatar() {
    if (widget.profile.avatarUrl.isEmpty) {
      _avatarFuture = null;
      return;
    }

    _avatarFuture = _fetchAvatar(widget.profile.avatarUrl);
  }

  Future<Uint8List?> _fetchAvatar(String url) async {
    try {
      final response = await sl<Dio>().get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.data == null) {
        return null;
      }

      return Uint8List.fromList(response.data!);
    } catch (e) {
      debugPrint('========== AVATAR ERROR ==========');
      debugPrint('Avatar URL: $url');
      debugPrint('Avatar Error: $e');
      debugPrint('===================================');

      return null;
    }
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 80.w,
      height: 80.h,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surfaceContainer,
      ),
      child: Icon(Icons.person, size: 40.sp, color: AppColors.textSecondary),
    );
  }

  Widget _buildAvatar() {
    if (widget.avatarPreview != null) {
      return ClipOval(
        child: Image.memory(
          widget.avatarPreview!,
          width: 90.w,
          height: 90.h,
          fit: BoxFit.cover,
        ),
      );
    }

    if (widget.profile.avatarUrl.isEmpty) {
      return _buildDefaultAvatar();
    }

    return FutureBuilder<Uint8List?>(
      future: _avatarFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: 80.w,
            height: 80.h,
            color: AppColors.surfaceContainer,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        final bytes = snapshot.data;

        if (bytes == null || bytes.isEmpty) {
          return _buildDefaultAvatar();
        }

        return ClipOval(
          child: Image.memory(
            bytes,
            width: 0.w,
            height: 80.h,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }

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
                      child: GestureDetector(
                        onTap:
                            widget.avatarPreview != null ||
                                widget.profile.avatarUrl.isNotEmpty
                            ? () => showProfilePhotoViewer(
                                context,
                                bytes: widget.avatarPreview,
                                imageUrl: widget.profile.avatarUrl,
                              )
                            : null,
                        child: _buildAvatar(),
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
                          onPressed: widget.isUpdatingAvatar
                              ? null
                              : widget.onChangeAvatar,
                          visualDensity: VisualDensity.compact,
                          style: IconButton.styleFrom(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          constraints: BoxConstraints.tightFor(
                            width: 30.w,
                            height: 30.h,
                          ),
                          padding: EdgeInsets.zero,
                          icon: widget.isUpdatingAvatar
                              ? SizedBox(
                                  width: 18.w,
                                  height: 18.h,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Icon(
                                  Icons.camera_alt_outlined,
                                  size: 15.sp,
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
                    AppText(
                      widget.profile.name,
                      style: AppTextStyles.headlineMedium,
                    ),

                    Gap(AppSpacing.space4.h),

                    AppText(
                      widget.profile.jobTitle,
                      style: AppTextStyles.bodyMedium,
                      color: AppColors.textSecondary,
                    ),

                    Gap(AppSpacing.space2.h),

                    AppText(
                      widget.profile.departmentName ?? widget.profile.roleLabel,
                      style: AppTextStyles.bodySmall,
                      color: AppColors.textSecondary,
                    ),

                    Gap(AppSpacing.space8.h),

                    ProfileStatusBadge(
                      text: [
                        widget.profile.status,
                        widget.profile.employmentType,
                      ].where((value) => value.isNotEmpty).join(' · '),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Gap(AppSpacing.space16.h),

          EmployeeInfo(profile: widget.profile),
        ],
      ),
    );
  }
}
