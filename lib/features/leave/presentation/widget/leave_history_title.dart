import 'package:flutter/material.dart';
import 'package:workwise/generated/app_localizations.dart';

class LeaveHistoryTitle extends StatelessWidget {
  const LeaveHistoryTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Row(
      children: [
        Text(
          localization.leaveHistory,
          style: Theme.of(context).textTheme.titleMedium,
        ),

        const Spacer(),

        TextButton(
          onPressed: () {},
          child: Text(
            localization.view,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}
