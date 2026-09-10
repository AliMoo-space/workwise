import 'package:flutter/material.dart';

class QuickSignInButton extends StatelessWidget {
  final VoidCallback onTap;

  const QuickSignInButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric( horizontal: 15),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Color(0xFF243B53)),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.fingerprint,
              color: Color(0xFF243B53),
              size: 28,
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Sign-In',
                    style: TextStyle(
                      color: Color(0xFF243B53),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Use Fingerprint or Face ID',
                    style: TextStyle(
                      color: Color(0xFF243B53),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color:Color(0xFF243B53),
            ),
          ],
        ),
      ),
    );
  }
}