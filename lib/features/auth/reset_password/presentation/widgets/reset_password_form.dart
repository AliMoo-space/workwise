import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/buttons/app_button.dart';
import 'package:workwise/core/design_system/widgets/inputs/app_text_field.dart';
import 'package:workwise/core/utils/app_validator.dart';
import 'package:workwise/features/auth/reset_password/presentation/cubit/reset_password_cubit.dart';
import 'package:workwise/features/auth/reset_password/presentation/cubit/reset_password_state.dart';

class ResetPasswordForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const ResetPasswordForm({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ResetPasswordCubit>();

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            controller: cubit.newPasswordController,
            label: 'New Password',
            hintText: 'Enter new password',
            type: AppTextFieldType.password,
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            validator: AppValidators.password(),
          ),
          const Gap(AppSpacing.space20),

          AppTextField(
            controller: cubit.confirmPasswordController,
            label: 'Confirm Password',
            hintText: 'Confirm new password',
            type: AppTextFieldType.password,
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please confirm your password';
              }
              if (value != cubit.newPasswordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const Gap(AppSpacing.space40),

          BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
            builder: (context, state) {
              return AppButton(
                text: 'Reset Password',
                height: 52.h,
                isLoading: state is ResetPasswordLoadingState,
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    FocusScope.of(context).unfocus();
                    cubit.resetPassword();
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}