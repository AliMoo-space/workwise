import 'package:flutter/material.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';

class OtpResendSection extends StatelessWidget {
  final bool canResend;
  final int startSeconds;
  final VoidCallback onResend;

  const OtpResendSection({
    super.key,
    required this.canResend,
    required this.startSeconds,
    required this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppText(
          "Didn't receive code? ",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        GestureDetector(
          onTap: canResend ? onResend : null,
          child: AppText(
            canResend
                ? 'Resend Code'
                : 'Resend in 00:${startSeconds.toString().padLeft(2, '0')}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: canResend
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
