import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';

class AtAGlanceHeader extends StatelessWidget {
  const AtAGlanceHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            "At a glance",
            style: TextStyle(
              fontSize: 18.sp,
              color: AppColors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Spacer(),
        TextButton(onPressed: () {}, child: const Text("Details")),
      ],
    );
  }
}
