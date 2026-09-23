import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/widgets/layout/app_divider.dart';
import 'package:workwise/core/localization/localization_extension.dart';
import '../../../../core/design_system/colors/app_colors.dart';
import 'drawer_menu_item.dart';

class DrawerFooter extends StatelessWidget {
  final VoidCallback onSettingsTap;
  final VoidCallback onLogoutTap;
  final String currentRoute;

  const DrawerFooter({
    super.key,
    required this.onSettingsTap,
    required this.onLogoutTap,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppDivider(color: AppColors.divider, thickness: 1, height: 1),
        Gap(8.h),
        DrawerMenuItem(
          icon: Icons.logout_outlined,
          title: context.l10n.logout,
          onTap: onLogoutTap,
        ),
        Gap(10.h),
      ],
    );
  }
}
