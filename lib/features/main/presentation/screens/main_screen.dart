import 'package:flutter/material.dart';
import 'package:workwise/features/attendance/presentation/screens/attendance_screen.dart';
import 'package:workwise/features/home/presentation/screens/home_screen.dart';
import 'package:workwise/features/main/presentation/widgets/main_bottom_navigation_bar.dart';
import 'package:workwise/features/profile/presentation/screen/profile_page.dart';
import 'package:workwise/features/setting/presentation/screens/settings_screen.dart';
import 'package:workwise/features/tasks/presentation/screens/tasks_screen.dart';


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
      const TasksScreen(),
      const ProfilePage(),
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
