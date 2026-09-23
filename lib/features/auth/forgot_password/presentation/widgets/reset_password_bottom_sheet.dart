import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:workwise/core/design_system/spacing/app_radius.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/buttons/app_button.dart';
import 'package:workwise/core/design_system/widgets/inputs/app_text_field.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';
import 'package:workwise/core/routing/app_routes.dart';
import 'package:workwise/core/utils/app_validator.dart';
import 'package:workwise/features/auth/forgot_password/presentation/cubit/forgot_password_cubit.dart';
import 'package:workwise/features/auth/forgot_password/presentation/cubit/forgot_password_state.dart';

class ResetPasswordBottomSheet extends StatefulWidget {
  const ResetPasswordBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.radius24),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (context) => BlocProvider(
        create: (context) => ForgotPasswordCubit(),
        child: const ResetPasswordBottomSheet(),
      ),
    );
  }

  @override
  State<ResetPasswordBottomSheet> createState() =>
      _ResetPasswordBottomSheetState();
}

class _ResetPasswordBottomSheetState extends State<ResetPasswordBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ForgotPasswordCubit>();
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        if (state is SendOtpSuccessState) {
          Navigator.pop(context);
          context.push(
            AppRoutes.otpVerificationScreen,
            extra: state.email,
          );
        } else if (state is SendOtpErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.space20,
            right: AppSpacing.space20,
            top: AppSpacing.space12,
            bottom: AppSpacing.space20 + bottomPadding,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(AppRadius.radius4),
                    ),
                  ),
                ),
                const Gap(AppSpacing.space16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      context.l10n.resetPasswordTitle,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close_rounded,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),

                AppText(
                  context.l10n.resetPasswordDescription,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const Gap(AppSpacing.space20),

                AppTextField(
                  controller: cubit.emailController,
                  label: context.l10n.workEmail,
                  hintText: context.l10n.workEmailHint,
                  type: AppTextFieldType.email,
                  prefixIcon: const Icon(Icons.email_outlined),
                  validator: AppValidators.email(
                    emptyMessage: context.l10n.enterWorkEmailMessage,
                    invalidMessage: context.l10n.invalidEmailFormatMessage,
                  ),
                ),
                const Gap(AppSpacing.space24),

                AppButton(
                  text: context.l10n.sendResetLink,
                  height: 50.h,
                  isLoading: state is SendOtpLoadingState,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      FocusScope.of(context).unfocus();
                      cubit.sendOtp();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}