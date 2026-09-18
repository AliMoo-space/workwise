import 'package:flutter/material.dart';
import 'package:workwise/generated/app_localizations.dart';

class PerformanceTrendHeader extends StatelessWidget {
  const PerformanceTrendHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Row(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            localization.performanceTrend,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
