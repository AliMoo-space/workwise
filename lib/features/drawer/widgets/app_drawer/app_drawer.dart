import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/feedback/app_dialog.dart';
import 'package:workwise/core/localization/localization_extension.dart';
import 'package:workwise/features/drawer/widgets/app_drawer/drawer_footer.dart';
import 'package:workwise/features/drawer/widgets/app_drawer/drawer_header.dart'
    as custom;
import 'package:workwise/features/drawer/widgets/app_drawer/drawer_menu.dart';

class AppDrawer extends StatelessWidget {
  final String? userName;
  final String? userEmail;
  final String? avatarUrl;

  const AppDrawer({super.key, this.userName, this.userEmail, this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).matchedLocation;

    return Drawer(
      backgroundColor: AppColors.surface,
      child: Column(
        children: [
          custom.DrawerHeader(
            userName: userName ?? 'User Name',
            userEmail: userEmail ?? 'user@example.com',
            avatarUrl: avatarUrl,
          ),

          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: AppSpacing.space16.r),
              children: [DrawerMenu(currentRoute: currentRoute)],
            ),
          ),

          DrawerFooter(
            currentRoute: currentRoute,
            onSettingsTap: () {
              // Navigate to settings when route is available.
            },
            onLogoutTap: () async {
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
      ),
    );
  }
}
