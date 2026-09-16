import 'package:flutter/material.dart';

import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';

class PerformanceTrendHeader extends StatelessWidget {
  const PerformanceTrendHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: AppText(
            context.l10n.performanceTrend,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
