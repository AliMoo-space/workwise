import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/spacing/app_radius.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/buttons/app_button.dart';
import 'package:workwise/core/design_system/widgets/inputs/app_text_field.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';
import 'package:workwise/core/utils/app_validator.dart';
import 'package:workwise/features/auth/forgot_password/presentation/widgets/reset_password_bottom_sheet.dart';
import 'package:workwise/features/auth/login/presentation/cubit/login_cubit.dart';
import 'package:workwise/features/auth/login/presentation/cubit/login_state.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();

    return Form(
      key: cubit.formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space20,
          vertical: AppSpacing.space16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              controller: cubit.emailController,
              label: context.l10n.workEmail,
              hintText: context.l10n.workEmailHint,
              type: AppTextFieldType.email,
              prefixIcon: Icon(
                Icons.mail_outline_rounded,
                color: Theme.of(context).colorScheme.outline,
                size: 20.sp,
              ),
              validator: AppValidators.email(
                emptyMessage: context.l10n.enterWorkEmailMessage,
                invalidMessage: context.l10n.invalidEmailFormatMessage,
              ),
            ),
            const Gap(AppSpacing.space16),

            AppTextField(
              controller: cubit.passwordController,
              label: context.l10n.password,
              hintText: context.l10n.passwordHint,
              type: AppTextFieldType.password,
              prefixIcon: Icon(
                Icons.lock_outline_rounded,
                color: Theme.of(context).colorScheme.outline,
                size: 20.sp,
              ),
              validator: AppValidators.password(
                emptyMessage: context.l10n.enterPasswordMessage,
              ),
            ),
            const Gap(AppSpacing.space16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    BlocBuilder<LoginCubit, LoginState>(
                      buildWhen: (_, current) =>
                          current is LoginKeepMeSignedInState,
                      builder: (context, state) {
                        return SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: Checkbox(
                            value: cubit.keepMeSignedIn,
                            activeColor: Theme.of(context).colorScheme.primary,
                            checkColor: Theme.of(context).colorScheme.surface,
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.outline,
                              width: 1.5.w,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppRadius.radius4,
                              ),
                            ),
                            onChanged: (val) => cubit.toggleKeepMeSignedIn(val),
                          ),
                        );
                      },
                    ),
                    const Gap(AppSpacing.space8),
                    AppText(
                      context.l10n.keepMeSignedIn,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    ResetPasswordBottomSheet.show(context);
                  },
                  child: AppText(
                    context.l10n.forgotPassword,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const Gap(AppSpacing.space24),

            BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) {
                return AppButton(
                  text: context.l10n.signIn,
                  height: 52.h,
                  isLoading: state is LoginLoadingState,
                  onPressed: () => cubit.login(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
