
// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:go_router/go_router.dart';
// import 'package:workwise/core/design_system/spacing/app_spacing.dart';
// import 'package:workwise/core/design_system/widgets/text/app_text.dart';
// import 'package:workwise/core/localization/localization_extension.dart';
// import 'package:workwise/core/routing/app_routes.dart';

// class LogoutTileWidget extends StatelessWidget {
//   final VoidCallback? onConfirmLogout;

//   const LogoutTileWidget({super.key, this.onConfirmLogout});

//   void _showLogoutDialog(BuildContext context) {
//     final theme = Theme.of(context);

//     showDialog(
//       context: context,
//       builder: (dialogContext) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: AppText(
//           context.l10n.logout,
//           style: theme.textTheme.titleMedium?.copyWith(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         content: AppText(
//           context.l10n.logoutConfirmationMessage,
//           style: theme.textTheme.bodyMedium,
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(dialogContext).pop(),
//             child: AppText(
//               context.l10n.cancel,
//               style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
//             ),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: theme.colorScheme.error,
//               foregroundColor: theme.colorScheme.onError,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             onPressed: () {
//               // 1. إغلاق الـ Dialog
//               Navigator.of(dialogContext).pop();

//               if (onConfirmLogout != null) {
//                 onConfirmLogout!();
//               } else {
//                 context.go(AppRoutes.loginScreen);
//               }
//             },
//             child: AppText(
//               context.l10n.logout,
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return InkWell(
//       onTap: () => _showLogoutDialog(context),
//       borderRadius: BorderRadius.circular(12),
//       child: Container(
//         padding: const EdgeInsets.symmetric(
//           horizontal: AppSpacing.space16,
//           vertical: AppSpacing.space16,
//         ),
//         decoration: BoxDecoration(
//           color: theme.colorScheme.errorContainer.withValues(alpha: 0.15),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: theme.colorScheme.error.withValues(alpha: 0.3),
//             width: 1,
//           ),
//         ),
//         child: Row(
//           children: [
//             Icon(Icons.logout_rounded, color: theme.colorScheme.error),
//             const Gap(AppSpacing.space12),
//             Expanded(
//               child: AppText(
//                 context.l10n.logout,
//                 style: theme.textTheme.titleSmall?.copyWith(
//                   fontWeight: FontWeight.bold,
//                   color: theme.colorScheme.error,
//                 ),
//               ),
//             ),
//             Icon(
//               Icons.arrow_forward_ios_rounded,
//               size: 16,
//               color: theme.colorScheme.error,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';
import 'package:workwise/core/routing/app_routes.dart';

class LogoutTileWidget extends StatelessWidget {
  final VoidCallback? onConfirmLogout;

  const LogoutTileWidget({super.key, this.onConfirmLogout});

  void _showLogoutDialog(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: AppText(
          context.l10n.logout,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: AppText(
          context.l10n.logoutConfirmationMessage,
          style: theme.textTheme.bodyMedium,
        ),
        actionsPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space16,
          vertical: AppSpacing.space16,
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(
                      color: theme.colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: AppText(
                    context.l10n.cancel,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const Gap(AppSpacing.space12),

              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: theme.colorScheme.error,
                    foregroundColor: theme.colorScheme.onError,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();

                    if (onConfirmLogout != null) {
                      onConfirmLogout!();
                    } else {
                      context.go(AppRoutes.loginScreen);
                    }
                  },
                  child: AppText(
                    context.l10n.logout,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => _showLogoutDialog(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space16,
          vertical: AppSpacing.space16,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.errorContainer.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.error.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.logout_rounded, color: theme.colorScheme.error),
            const Gap(AppSpacing.space12),
            Expanded(
              child: AppText(
                context.l10n.logout,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.error,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: theme.colorScheme.error,
            ),
          ],
        ),
      ),
    );
  }
}