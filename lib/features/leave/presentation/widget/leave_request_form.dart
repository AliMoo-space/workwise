import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';

import 'package:workwise/core/design_system/spacing/app_radius.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/buttons/app_button.dart';
import 'package:workwise/core/design_system/widgets/feedback/app_snack_bar.dart';
import 'package:workwise/core/design_system/widgets/inputs/app_dropdown.dart';
import 'package:workwise/core/design_system/widgets/inputs/app_text_field.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';
import 'package:workwise/core/utils/app_helpers.dart';
import 'package:workwise/core/utils/app_validator.dart';
import 'package:workwise/features/leave/domain/entity/leave_request_entity.dart';
import 'package:workwise/features/leave/presentation/cubit/leave_history/leave_history_cubit.dart';
import 'package:workwise/features/leave/presentation/cubit/leave_request/leave_request_cubit.dart';
import 'package:workwise/features/leave/presentation/cubit/leave_request/leave_request_state.dart';

class LeaveRequestForm extends StatefulWidget {
  const LeaveRequestForm({super.key});

  @override
  State<LeaveRequestForm> createState() => _LeaveRequestFormState();
}

class _LeaveRequestFormState extends State<LeaveRequestForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();

  File? selectedImage;
  int? selectedLeaveTypeId;

  @override
  void dispose() {
    startDateController.dispose();
    endDateController.dispose();
    reasonController.dispose();

    super.dispose();
  }

  void submitForm() {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    final leaveTypeId = selectedLeaveTypeId;

    if (leaveTypeId == null) {
      return;
    }

    final request = LeaveRequestEntity(
      leaveTypeId: leaveTypeId,
      startDate: startDateController.text,
      endDate: endDateController.text,
      reason: reasonController.text.trim(),
      image: selectedImage?.path,
    );

    context.read<LeaveRequestCubit>().createLeaveRequest(request);
  }

  void clearForm() {
    setState(() {
      selectedLeaveTypeId = null;
      selectedImage = null;

      startDateController.clear();
      endDateController.clear();
      reasonController.clear();
    });

    formKey.currentState?.reset();
  }

  Future<void> pickImage() async {
    final image = await AppHelpers.pickImage();

    if (image == null || !mounted) {
      return;
    }

    setState(() {
      selectedImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<LeaveRequestCubit, LeaveRequestState>(
      listener: (context, state) {
        if (state is LeaveRequestSuccess) {
          clearForm();

          context.read<LeaveHistoryCubit>().getLeaveHistory();

          AppSnackBar.success(
            context,
            message: context.l10n.leaveRequestSubmittedSuccessfully,
          );
        }

        if (state is LeaveRequestFailure) {
          AppSnackBar.error(context, message: state.message);
        }
      },
      child: AppCard(
        height: 600.h,
        width: double.infinity,
        padding: EdgeInsets.all(15.r),
        backgroundColor: theme.colorScheme.onError,
        borderRadius: AppRadius.radius32.r,
        border: Border.all(color: theme.colorScheme.outlineVariant, width: 1.w),
        boxShadow: const [],
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Align(
                alignment: AlignmentDirectional.topStart,
                child: AppText(
                  context.l10n.leaveType,
                  style: theme.textTheme.labelLarge,
                ),
              ),

              Gap(AppSpacing.space8.h),

              AppDropdown<int>(
                hint: context.l10n.selectLeaveType,
                fillColor: theme.colorScheme.surface,
                borderRadius: AppRadius.radius32.r,
                items: [
                  DropdownMenuItem(
                    value: 1,
                    child: AppText(context.l10n.annualLeave),
                  ),
                  DropdownMenuItem(
                    value: 2,
                    child: AppText(context.l10n.sickLeave),
                  ),
                  DropdownMenuItem(
                    value: 3,
                    child: AppText(context.l10n.emergencyLeave),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedLeaveTypeId = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return context.l10n.pleaseSelectLeaveType;
                  }

                  return null;
                },
              ),

              Gap(AppSpacing.space16.h),

              Row(
                children: [
                  Expanded(
                    child: _buildDateField(
                      context: context,
                      label: context.l10n.startDate,
                      controller: startDateController,
                      validatorMessage: context.l10n.pleaseSelectStartDate,
                    ),
                  ),

                  Gap(AppSpacing.space16.w),

                  Expanded(
                    child: _buildDateField(
                      context: context,
                      label: context.l10n.endDate,
                      controller: endDateController,
                      validatorMessage: context.l10n.pleaseSelectEndDate,
                    ),
                  ),
                ],
              ),

              Gap(AppSpacing.space16.h),

              Align(
                alignment: AlignmentDirectional.topStart,
                child: AppText(
                  context.l10n.reason,
                  style: theme.textTheme.labelLarge,
                ),
              ),

              Gap(AppSpacing.space8.h),

              AppTextField(
                controller: reasonController,
                hintText: context.l10n.reasonHint,
                type: AppTextFieldType.multiline,
                fillColor: theme.colorScheme.surface,
                borderRadius: AppRadius.radius32.r,
                maxLines: 3,
                validator: AppValidators.required(
                  message: context.l10n.pleaseEnterReason,
                ),
              ),

              Gap(AppSpacing.space20.h),

              GestureDetector(
                onTap: pickImage,
                child: AppCard(
                  height: 130.h,
                  width: double.infinity,
                  padding: EdgeInsets.zero,
                  backgroundColor: theme.colorScheme.surface,
                  borderRadius: AppRadius.radius16.r,
                  border: Border.all(
                    width: .5.w,
                    color: theme.colorScheme.outlineVariant,
                  ),
                  boxShadow: const [],
                  child: selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(
                            AppRadius.radius16.r,
                          ),
                          child: Image.file(
                            selectedImage!,
                            width: double.infinity,
                            height: 130.h,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.cloud_upload),

                            AppText(
                              context.l10n.attachSupportingDocument,
                              style: theme.textTheme.titleSmall,
                            ),

                            Gap(AppSpacing.space4.h),

                            AppText(context.l10n.uploadImage),
                          ],
                        ),
                ),
              ),

              Gap(AppSpacing.space8.h),

              BlocBuilder<LeaveRequestCubit, LeaveRequestState>(
                builder: (context, state) {
                  final isLoading = state is LeaveRequestLoading;

                  return AppButton(
                    text: context.l10n.submitRequest,
                    textStyle: theme.textTheme.headlineSmall,
                    onPressed: submitForm,
                    isLoading: isLoading,
                    enabled: !isLoading,
                    height: 48.h,
                    width: double.infinity,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    required String validatorMessage,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(label, style: theme.textTheme.labelLarge),

        Gap(AppSpacing.space8.h),

        AppTextField(
          controller: controller,
          hintText: context.l10n.dateFormat,
          readOnly: true,
          onTap: () {
            AppHelpers.selectDate(context, controller);
          },
          suffixIcon: const Icon(Icons.calendar_today_outlined),
          fillColor: theme.colorScheme.surface,
          borderRadius: AppRadius.radius32.r,
          validator: AppValidators.required(message: validatorMessage),
        ),
      ],
    );
  }
}
