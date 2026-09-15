import 'package:flutter/material.dart';
import 'package:workwise/generated/app_localizations.dart';

class AtAGlanceHeader extends StatelessWidget {
  const AtAGlanceHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Row(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            localization.atAGlance,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ],
    );
  }
}
