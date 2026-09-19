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
        DrawerSection(children: [
            
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
      ],
    );
  }
}
