import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';
import 'package:workwise/core/routing/app_routes.dart';
import 'package:workwise/features/auth/fingerprint/presentation/logic/finger_print_cubit.dart';
import 'package:workwise/features/auth/fingerprint/presentation/logic/finger_print_state.dart';

class FingerPrintWidget extends StatelessWidget {
  const FingerPrintWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FingerprintCubit>();

    return BlocBuilder<FingerprintCubit, FingerprintState>(
      builder: (context, state) {
        Color borderColor = Theme.of(context).colorScheme.outline;
        Color iconColor = Theme.of(context).colorScheme.primary;

        if (state is FingerprintSuccessState) {
          borderColor = Theme.of(context).colorScheme.tertiary;
          iconColor = Theme.of(context).colorScheme.tertiary;
        } else if (state is FingerprintErrorState) {
          borderColor = Theme.of(context).colorScheme.error;
          iconColor = Theme.of(context).colorScheme.error;
        }

        return Column(
          children: [
            const Gap(AppSpacing.space32),
            GestureDetector(
              onTap: () => cubit.authenticateWithBiometrics(),
              child: Container(
                width: 140.w,
                height: 140.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.surface,
                  border: Border.all(color: borderColor, width: 2.w),
                ),
                child: Center(
                  child: Icon(
                    Icons.fingerprint_rounded,
                    size: 70.sp,
                    color: iconColor,
                  ),
                ),
              ),
            ),
            const Gap(AppSpacing.space24),
            AppText(
              context.l10n.tapToScanFingerprintFaceID,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Gap(AppSpacing.space40),
            GestureDetector(
              onTap: () {
                context.go(AppRoutes.loginScreen);
              },
              child: AppText(
                context.l10n.useEmailAndPasswordInstead,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
