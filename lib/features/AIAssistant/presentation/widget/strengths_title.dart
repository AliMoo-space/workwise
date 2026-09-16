import 'package:flutter/material.dart';

import 'package:workwise/core/design_system/widgets/text/app_text.dart';

class StrengthsTitle extends StatelessWidget {
  const StrengthsTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: AppText(
        "Strengths",
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
