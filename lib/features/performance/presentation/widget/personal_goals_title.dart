import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';
import 'package:workwise/core/routing/app_routes.dart';

class PersonalGoalsTitle extends StatelessWidget {
  const PersonalGoalsTitle({super.key, required this.hasGoals});

  final bool hasGoals;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: AppText(
            context.l10n.personalGoals,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.start,
          ),
        ),
        const Spacer(),
        if (hasGoals)
          TextButton(
            onPressed: () {
              context.push(AppRoutes.goalViewAll);
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
