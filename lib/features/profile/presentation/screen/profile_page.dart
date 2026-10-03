import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/buttons/app_button.dart';
import 'package:workwise/core/design_system/widgets/feedback/app_dialog.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';
import 'package:workwise/features/profile/widgets/job_details_section.dart';
import 'package:workwise/features/profile/widgets/profile_card.dart';
import 'package:workwise/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:workwise/features/profile/presentation/cubit/profile_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Uint8List? _avatarPreview;

  Future<void> _changeAvatar() async {
    final avatar = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (avatar == null) return;

    final bytes = await avatar.readAsBytes();
    if (!mounted) return;

    setState(() => _avatarPreview = bytes);

    await context.read<ProfileCubit>().updateProfile(
      language: Localizations.localeOf(context).languageCode,
      avatar: avatar,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: AppText(
          context.l10n.profile,
          style: TextStyle(
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w700,
            fontSize: 22.sp,
            color: AppColors.textPrimary,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.space16.r),
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.profile != null) ...[
                    ProfileCard(
                      profile: state.profile!,
                      avatarPreview: _avatarPreview,
                      isUpdatingAvatar: state.isLoading,
                      onChangeAvatar: _changeAvatar,
                    ),
                    if (state.isFailure && state.message != null) ...[
                      Gap(AppSpacing.space8.h),
                      AppText(
                        state.message!,
                        color: AppColors.textSecondary,
                      ),
                    ],
                    Gap(AppSpacing.space16.h),
                    JobDetailsSection(profile: state.profile!),
                  ] else if (state.isLoading ||
                      state.status == ProfileStatus.initial)
                    Skeletonizer(enabled: true, child: _ProfileSkeleton())
                  else if (state.isFailure)
                    Center(
                      child: AppText(
                        state.message ?? context.l10n.profile,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  Gap(AppSpacing.space20.h),
                  AppButton(
                    text: context.l10n.logout,
                    variant: AppButtonVariant.danger,
                    onPressed: () async {
                      final confirmed = await AppDialog.confirm(
                        context,
                        title: context.l10n.logout,
                        message: context.l10n.logoutConfirmMessage,
                        confirmText: context.l10n.logout,
                        cancelText: context.l10n.cancel,
                      );

                      if (confirmed && context.mounted) {
                        context.go('/loginScreen');
                      }
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ProfileSkeleton extends StatelessWidget {
  const _ProfileSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCard(
          padding: EdgeInsets.all(AppSpacing.space16.r),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80.w,
                height: 80.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceContainer,
                ),
              ),
              Gap(AppSpacing.space16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 18.h,
                      width: 150.w,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    Gap(AppSpacing.space8.h),
                    Container(
                      height: 14.h,
                      width: 110.w,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    Gap(AppSpacing.space8.h),
                    Container(
                      height: 12.h,
                      width: 130.w,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Gap(AppSpacing.space16.h),
        AppCard(
          padding: EdgeInsets.all(AppSpacing.space16.r),
          child: Column(
            children: List.generate(4, (index) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == 3 ? 0 : AppSpacing.space12.h,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32.w,
                      height: 32.h,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    Gap(AppSpacing.space12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 12.h,
                            width: 100.w,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainer,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                          ),
                          Gap(AppSpacing.space4.h),
                          Container(
                            height: 14.h,
                            width: 180.w,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainer,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
