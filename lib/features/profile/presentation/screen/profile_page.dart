import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/buttons/app_button.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/features/profile/widgets/job_details_section.dart';
import 'package:workwise/features/profile/widgets/profile_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const AppText('Profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.space16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProfileCard(),

              Gap(AppSpacing.space16.h),

              const JobDetailsSection(),
              Gap(AppSpacing.space20.h),
              AppButton(
                text: "Logout",
                fontSize: 14.sp,
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/login'),
                variant: AppButtonVariant.danger,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
