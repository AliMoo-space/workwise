import 'package:flutter/material.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF243B53),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Center(
            child: Container(
              // padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
              color:  Colors.transparent,
            ),
            child: Image.asset(
              'assets/images/logo2.jpeg',
              height: 150,
              width: 150,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Welcome Back',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 6),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Sign in with your corporate credentials',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ),
      ],
      ),
    );
  }
}