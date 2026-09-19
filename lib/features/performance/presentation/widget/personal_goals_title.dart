import 'package:flutter/material.dart';

import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';

class PersonalGoalsTitle extends StatelessWidget {
  const PersonalGoalsTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: AppText(
        context.l10n.personalGoals,
        style: Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.start,
      ),
    );
  }
}
