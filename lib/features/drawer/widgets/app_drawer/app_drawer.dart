import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/feedback/app_dialog.dart';
import 'package:workwise/core/localization/local_cubit.dart';
import 'package:workwise/core/localization/localization_extension.dart';
import 'package:workwise/core/services/service_locator.dart';
import 'package:workwise/core/storage/local_storage.dart';
import 'package:workwise/features/auth/login/data/Repository/auth_repository.dart';
import 'package:workwise/features/drawer/widgets/app_drawer/drawer_footer.dart';
import 'package:workwise/features/drawer/widgets/app_drawer/drawer_header.dart'
    as custom;
import 'package:workwise/features/drawer/widgets/app_drawer/drawer_menu.dart';
import 'package:workwise/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:workwise/features/profile/presentation/cubit/profile_state.dart';

class AppDrawer extends StatelessWidget {
  final String? userName;
  final String? userEmail;
  final String? avatarUrl;

  const AppDrawer({super.key, this.userName, this.userEmail, this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).matchedLocation;
    final employeeId = sl<LocalStorage>().getUserId();
    final language = sl<LocaleCubit>().state.languageCode;

    return BlocProvider(
      create: (_) =>
          sl<ProfileCubit>()
            ..getProfile(employeeId: employeeId, language: language),
      child: Drawer(
        backgroundColor: AppColors.surface,
        child: Column(
          children: [
            BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                final profile = state.profile;
                final profileAvatar = profile?.avatarUrl;

                return custom.DrawerHeader(
                  userName: userName ?? profile?.name ?? '',
                  userEmail: userEmail ?? profile?.email ?? '',
                  avatarUrl:
                      avatarUrl ??
                      (profileAvatar != null && profileAvatar.isNotEmpty
                          ? profileAvatar
                          : null),
                );
              },
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
                  await sl<AuthRepository>().logout();
                  if (!context.mounted) return;
                  context.go('/loginScreen');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
