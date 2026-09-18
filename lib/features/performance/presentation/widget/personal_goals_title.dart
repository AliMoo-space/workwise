import 'package:flutter/material.dart';
import 'package:workwise/generated/app_localizations.dart';

class PersonalGoalsTitle extends StatelessWidget {
  const PersonalGoalsTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        localization.personalGoals,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
