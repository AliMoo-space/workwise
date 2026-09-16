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
              icon: Icons.home_sharp,
              title: 'Home',
              isSelected: currentRoute == AppRoutes.homeScreen,
              onTap: () {
                Navigator.of(context).pop();

                if (currentRoute != AppRoutes.homeScreen) {
                  context.go(AppRoutes.homeScreen);
                }
              },
            ),

            DrawerMenuItem(
              icon: Icons.task_outlined,
              title: 'Tasks',
              isSelected: currentRoute == AppRoutes.tasksScreen,
              onTap: () {
                Navigator.of(context).pop();

                if (currentRoute != AppRoutes.tasksScreen) {
                  context.go(AppRoutes.tasksScreen);
                }
              },
            ),

            DrawerMenuItem(
              icon: Icons.note_outlined,
              title: 'Notes',
              isSelected: currentRoute == AppRoutes.notesScreen,
              onTap: () {
                Navigator.of(context).pop();

                if (currentRoute != AppRoutes.notesScreen) {
                  context.go(AppRoutes.notesScreen);
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
              isSelected: currentRoute == '/profile',
              onTap: () {
                Navigator.of(context).pop();

                if (currentRoute != '/profile') {
                  context.go('/profile');
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
