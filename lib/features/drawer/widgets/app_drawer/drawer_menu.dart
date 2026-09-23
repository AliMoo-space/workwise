import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/localization_extension.dart';
import '../../../../core/routing/app_routes.dart';
import 'drawer_menu_item.dart';
import 'drawer_section.dart';

class DrawerMenu extends StatelessWidget {
  final String currentRoute;

  const DrawerMenu({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DrawerSection(
          children: [
            DrawerMenuItem(
              icon: Icons.bar_chart_outlined,
              title: context.l10n.performance,
              isSelected: currentRoute == AppRoutes.performanceScreen,
              onTap: () {
                Navigator.of(context).pop();

                if (currentRoute != AppRoutes.performanceScreen) {
                  context.push(AppRoutes.performanceScreen);
                }
              },
            ),
          ],
        ),

        DrawerSection(
          title: context.l10n.account,
          children: [
            DrawerMenuItem(
              icon: Icons.person_outline,
              title: context.l10n.profile,
              isSelected: currentRoute == AppRoutes.profilePage,
              onTap: () {
                if (currentRoute != AppRoutes.profilePage) {
                  context.push(AppRoutes.profilePage);
                }
              },
            ),
          ],
        ),
        DrawerMenuItem(
          icon: Icons.settings_outlined,
          title: context.l10n.settings,
          isSelected: currentRoute == '/setting',
          onTap: () {
            if (currentRoute != '/setting') {
              context.push(AppRoutes.settingsScreen);
            }
          },
        ),
      ],
    );
  }
}
