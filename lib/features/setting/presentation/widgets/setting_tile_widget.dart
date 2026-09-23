// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
// import 'package:gap/gap.dart';
// import 'package:workwise/core/design_system/spacing/app_radius.dart';
// import 'package:workwise/core/design_system/spacing/app_spacing.dart';
// import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
// import 'package:workwise/core/design_system/widgets/text/app_text.dart';

// class SettingTileWidget extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String subtitle;
//   final Widget trailing;

//   const SettingTileWidget({
//     super.key,
//     required this.icon,
//     required this.title,
//     required this.subtitle,
//     required this.trailing,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return AppCard(
//       borderRadius: AppRadius.radius16,
//       backgroundColor: theme.colorScheme.surfaceContainerLow,
//       border: Border.all(
//         color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
//       ),
//       padding: const EdgeInsets.all(AppSpacing.space16),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(AppSpacing.space12),
//             decoration: BoxDecoration(
//               color: theme.colorScheme.surfaceContainerHigh,
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               icon,
//               size: 22.sp,
//               color: theme.colorScheme.onSurfaceVariant,
//             ),
//           ),
//           const Gap(AppSpacing.space12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 AppText(
//                   title,
//                   style: theme.textTheme.bodyLarge?.copyWith(
//                     fontWeight: FontWeight.bold,
//                     color: theme.colorScheme.onSurface,
//                   ),
//                 ),
//                 const Gap(AppSpacing.space2),
//                 AppText(
//                   subtitle,
//                   style: theme.textTheme.bodySmall?.copyWith(
//                     color: theme.colorScheme.onSurfaceVariant,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           trailing,
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/spacing/app_radius.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';

class SettingTileWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? iconBackgroundColor;
  final Color? iconColor;

  const SettingTileWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.onTap,
    this.backgroundColor,
    this.iconBackgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AppCard(
        borderRadius: AppRadius.radius16,
        backgroundColor:
            backgroundColor ?? theme.colorScheme.surfaceContainerLow,
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        padding: const EdgeInsets.all(AppSpacing.space16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.space12),
              decoration: BoxDecoration(
                color: iconBackgroundColor ??
                    theme.colorScheme.surfaceContainerHigh,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 22.sp,
                color: iconColor ?? theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const Gap(AppSpacing.space12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const Gap(AppSpacing.space2),
                  AppText(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}