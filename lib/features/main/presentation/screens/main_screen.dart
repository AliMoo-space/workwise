import 'package:flutter/material.dart';
import 'package:workwise/features/AIAssistant/presentation/screens/AI_assistant.dart';
import 'package:workwise/features/home/presentation/screens/home_screen.dart';
import 'package:workwise/features/leave/presentation/screens/leave_screen.dart';
import 'package:workwise/features/main/presentation/widgets/main_bottom_navigation_bar.dart';
import 'package:workwise/features/tasks/presentation/screens/tasks_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  bool isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      HomeScreen(
        onDrawerChanged: (isOpen) {
          setState(() {
            isDrawerOpen = isOpen;
          });
        },
      ),
      // const AttendanceScreen(),
      TasksScreen(),
      const Leavescreen(),
      const AiAssistant(),
    ];

    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: isDrawerOpen
          ? null
          : SafeArea(
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
