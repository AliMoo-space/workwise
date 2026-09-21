import 'package:flutter/material.dart';

import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';

class DevelopmentAreasTitle extends StatelessWidget {
  const DevelopmentAreasTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.topStart,
      child: AppText(
        context.l10n.developmentAreas,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
