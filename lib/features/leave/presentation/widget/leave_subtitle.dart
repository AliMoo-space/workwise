import 'package:flutter/material.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';

class LeaveSubtitle extends StatelessWidget {
  const LeaveSubtitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        "Balances, requests, and personal goals",
        style: TextStyle(color: AppColors.black),
      ),
    );
  }
}
