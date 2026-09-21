import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
              title: 'Performance',
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
          title: 'ACCOUNT',
          children: [
            DrawerMenuItem(
              icon: Icons.person_outline,
              title: 'Profile',
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
          title: 'Settings',
          isSelected: currentRoute == '/setting',
          onTap: () {
            Navigator.of(context).pop();

            if (currentRoute != '/setting') {
              context.go('/setting');
            }
          },
        ),
        DrawerMenuItem(
          icon: Icons.language_outlined,
          title: 'language',
          isSelected: currentRoute == '/settings',
          onTap: () {
            Navigator.of(context).pop();

            if (currentRoute != '/settings') {
              context.go('/settings');
            }
          },
        ),
        DrawerMenuItem(
          icon: Icons.help_outline,
          title: 'Help & Support',
          isSelected: currentRoute == '/help',
          onTap: () {
            Navigator.of(context).pop();

            if (currentRoute != '/help') {
              context.go('/help');
            }
          },
        ),
      ],
    );
  }
}
