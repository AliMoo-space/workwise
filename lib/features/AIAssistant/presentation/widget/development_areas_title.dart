import 'package:flutter/material.dart';
import 'package:workwise/generated/app_localizations.dart';

class DevelopmentAreasTitle extends StatelessWidget {
  const DevelopmentAreasTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        l10n.developmentAreas,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
