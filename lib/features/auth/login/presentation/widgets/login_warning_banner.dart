import 'package:flutter/material.dart';

class LoginWarningBanner extends StatelessWidget {
  final String message;
  final bool isSessionExpired;

  const LoginWarningBanner({
    super.key,
    required this.message,
    this.isSessionExpired = false,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isSessionExpired
        ? const Color(0xFF3A301D) // بني/أصفر داكن لانتهاء الجلسة
        : const Color(0xFF3B2023); // أحمر داكن للخطأ

    final borderColor = isSessionExpired
        ? Colors.amber.shade700
        : Colors.red.shade700;

    final iconColor = isSessionExpired ? Colors.amber : Colors.redAccent;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: iconColor, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: iconColor,
                fontSize: 13,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}