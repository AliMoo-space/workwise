import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/generated/app_localizations.dart';

class FeedbackCard extends StatelessWidget {
  const FeedbackCard({super.key, required this.feedback});

  final String feedback;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppCard(
      padding: EdgeInsets.all(12.r),
      borderRadius: 12.r,
      boxShadow: [],
      child: AppText(l10n.managerFeedback(feedback)),
    );
  }
}import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/generated/app_localizations.dart';

class FeedbackCard extends StatelessWidget {
  const FeedbackCard({super.key, required this.feedback});
  final String feedback;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppCard(
      padding: EdgeInsets.all(12.r),
      borderRadius: 12.r,
      boxShadow: [],
      child: AppText(l10n.managerFeedback(feedback)),
    );
  }
}
