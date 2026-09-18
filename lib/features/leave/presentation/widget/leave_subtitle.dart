import 'package:flutter/material.dart';
import 'package:workwise/generated/app_localizations.dart';

class LeaveSubtitle extends StatelessWidget {
  const LeaveSubtitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        AppLocalizations.of(context).balancesRequestsGoals,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
