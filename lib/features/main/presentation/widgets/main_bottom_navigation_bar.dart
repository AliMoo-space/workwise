import 'package:flutter/material.dart';
import 'dart:math' as math;
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
    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 8.h),
      child: SizedBox(
        height: math.max(60.h, 72),
        child: Material(
          color: AppColors.primary,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(28.r),
          elevation: 8,
          shadowColor: Colors.black.withValues(alpha: 0.22),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: SizedBox(
                  width: math.min(420.w, constraints.maxWidth),
                  child: BottomNavigationBar(
                    currentIndex: currentIndex,
                    onTap: onTap,
                    backgroundColor: Colors.transparent,
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
              );
            },
          ),
        ),
      ),
    );
  }
}
