import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/design_system/widgets/media/profile_photo_viewer.dart';
import 'package:workwise/core/services/service_locator.dart';

import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/typography/app_text_styles.dart';

class DrawerHeader extends StatefulWidget {
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
  State<DrawerHeader> createState() => _DrawerHeaderState();
}

class _DrawerHeaderState extends State<DrawerHeader> {
  Future<Uint8List?>? _avatarFuture;

  @override
  void initState() {
    super.initState();
    _loadAvatar();
  }

  @override
  void didUpdateWidget(covariant DrawerHeader oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.avatarUrl != widget.avatarUrl) {
      _loadAvatar();
    }
  }

  void _loadAvatar() {
    if (widget.avatarUrl == null || widget.avatarUrl!.isEmpty) {
      _avatarFuture = null;
      return;
    }

    _avatarFuture = _fetchAvatar(widget.avatarUrl!);
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
      debugPrint('========== DRAWER AVATAR ERROR ==========');
      debugPrint('Avatar URL: $url');
      debugPrint('Avatar Error: $e');
      debugPrint('=========================================');

      return null;
    }
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 72.r,
      height: 72.r,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.secondary,
      ),
      alignment: Alignment.center,
      child: Icon(Icons.person, size: 36.r, color: AppColors.onPrimary),
    );
  }

  Widget _buildAvatar() {
    if (widget.avatarUrl == null || widget.avatarUrl!.isEmpty) {
      return _buildDefaultAvatar();
    }

    return FutureBuilder<Uint8List?>(
      future: _avatarFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: 72.r,
            height: 72.r,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.secondary,
            ),
            alignment: Alignment.center,
            child: SizedBox(
              width: 22.r,
              height: 22.r,
              child: const CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        final bytes = snapshot.data;

        if (bytes == null || bytes.isEmpty) {
          return _buildDefaultAvatar();
        }

        return Container(
          width: 90.w,
          height: 90.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.onPrimary.withValues(alpha: 0.25),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.memory(
              bytes,
              width: 90.w,
              height: 90.h,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.r),
      decoration: const BoxDecoration(color: AppColors.primary),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: widget.avatarUrl != null && widget.avatarUrl!.isNotEmpty
                  ? () => showProfilePhotoViewer(
                      context,
                      imageUrl: widget.avatarUrl,
                    )
                  : null,
              child: _buildAvatar(),
            ),

            Gap(16.h),

            AppText(
              widget.userName,
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.onPrimary,
              ),
            ),

            Gap(4.h),

            AppText(
              widget.userEmail,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.onPrimary.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
