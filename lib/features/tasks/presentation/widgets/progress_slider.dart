import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';

class ProgressSlider extends StatelessWidget {
  const ProgressSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  final int value;
  final ValueChanged<double> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          AppText(
            'Progress',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.sp),
          ),
          Spacer(),
          AppText(
            '$value%',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15.sp,
              color: AppColors.black,
            ),
          ),
        ],
      ),
      SliderTheme(
        data: SliderTheme.of(context).copyWith(
          activeTrackColor: const Color(0xFF4A6999),
          inactiveTrackColor: const Color(0xFFE9EDF5),
          thumbColor: const Color(0xFF3B5682),
          trackHeight: 4.h,
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7.r),
          overlayColor: const Color.fromRGBO(59, 86, 130, 0.15),
        ),
        child: Slider(
          value: value.clamp(0, 100).toDouble(),
          min: 0,
          max: 100,
          // divisions: 20,
          label: '$value%',
          onChanged: enabled ? onChanged : null,
        ),
      ),
    ],
  );
}
