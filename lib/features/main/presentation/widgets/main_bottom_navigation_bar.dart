import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import 'package:workwise/core/design_system/colors/app_colors.dart';
import 'package:workwise/core/localization/localization_extension.dart';

class MainBottomNavigationBar extends StatelessWidget {
  const MainBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28.r),
          topRight: Radius.circular(28.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12.dg,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28.r),
          topRight: Radius.circular(28.r),
        ),
        child: Center(
          child: SizedBox(
            width: 330.w,
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: onTap,
              backgroundColor: AppColors.primary,
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white.withValues(alpha: 0.55),
              selectedFontSize: 10.dg,
              unselectedFontSize: 9.dg,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home_rounded),
                  label: context.l10n.homeScreen,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.task_alt_rounded),
                  activeIcon: Icon(Icons.task_alt_sharp),
                  label: context.l10n.tasks,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.beach_access_outlined),
                  activeIcon: Icon(Icons.beach_access_rounded),
                  label: context.l10n.leave,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.auto_awesome),
                  activeIcon: Icon(Icons.auto_awesome),
                  label: context.l10n.aiAssistant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
