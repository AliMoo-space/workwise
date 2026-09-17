import 'package:flutter/material.dart';
import 'package:workwise/core/localization/localization_extension.dart';
import 'package:workwise/features/attendance/presentation/screens/attendance_screen.dart';
import 'package:workwise/features/home/presentation/screens/home_screen.dart';
import 'package:workwise/features/main/presentation/widgets/main_bottom_navigation_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      const HomeScreen(),
      const AttendanceScreen(),
      Center(child: Text(context.l10n.orders)),
      Center(child: Text(context.l10n.profile)),
    ];

    return Scaffold(
      body: screens[currentIndex],

      bottomNavigationBar: SafeArea(
        top: false,
        child: MainBottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
