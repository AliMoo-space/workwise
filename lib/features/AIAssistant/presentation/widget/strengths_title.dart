import 'package:flutter/material.dart';

import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';

class StrengthsTitle extends StatelessWidget {
  const StrengthsTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.topStart,
      child: AppText(
        context.l10n.strengths,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
