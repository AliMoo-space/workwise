import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';
import 'package:workwise/core/routing/app_routes.dart';

class LeaveHistoryTitle extends StatelessWidget {
  const LeaveHistoryTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppText(
          context.l10n.leaveHistory,
          style: Theme.of(context).textTheme.titleMedium,
        ),

        const Spacer(),

        TextButton(
          onPressed: () {
            context.push(AppRoutes.leaveScreen);
          },
          child: AppText(
            context.l10n.view,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}
