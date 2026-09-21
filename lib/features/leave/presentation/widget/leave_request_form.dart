// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/spacing/app_radius.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/buttons/app_button.dart';
import 'package:workwise/core/design_system/widgets/inputs/app_dropdown.dart';
import 'package:workwise/core/design_system/widgets/inputs/app_text_field.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';
import 'package:workwise/core/utils/app_helpers.dart';
import 'package:workwise/core/utils/app_validator.dart';

// ignore: must_be_immutable
class LeaveRequestForm extends StatefulWidget {
  const LeaveRequestForm({super.key});

  @override
  State<LeaveRequestForm> createState() => _LeaveRequestFormState();
}

class _LeaveRequestFormState extends State<LeaveRequestForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  File? selectedImage;
  String? selectedLeaveType;
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();

  @override
  void dispose() {
    startDateController.dispose();
    endDateController.dispose();
    reasonController.dispose();

    super.dispose();
  }

  void submitForm() {
    if (formKey.currentState!.validate()) {
      // Form is valid.
      // Submit the leave request here.
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      height: 560.h,
      width: double.infinity,
      padding: EdgeInsets.all(15.r),
      backgroundColor: Theme.of(context).colorScheme.onError,
      borderRadius: AppRadius.radius32.r,
      border: Border.all(
        color: Theme.of(context).colorScheme.outlineVariant,
        width: 1.w,
      ),
      boxShadow: const [],
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Align(
              alignment: AlignmentDirectional.topStart,
              child: AppText(
                context.l10n.leaveType,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),

            Gap(AppSpacing.space8.h),

            AppDropdown<String>(
              hint: context.l10n.selectLeaveType,
              fillColor: Theme.of(context).colorScheme.surface,
              borderRadius: AppRadius.radius32.r,
              items: [
                DropdownMenuItem(
                  value: 'Annual Leave',
                  child: AppText(context.l10n.annualLeave),
                ),
                DropdownMenuItem(
                  value: 'Casual Leave',
                  child: AppText(context.l10n.casualLeave),
                ),
                DropdownMenuItem(
                  value: 'Sick Leave',
                  child: AppText(context.l10n.sickLeave),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedLeaveType = value;
                });
              },
              validator: AppValidators.required(
                message: 'Please select a leave type.',
              ),
            ),

            Gap(AppSpacing.space16.h),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        context.l10n.startDate,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),

                      Gap(AppSpacing.space8.h),

                      AppTextField(
                        controller: startDateController,
                        hintText: context.l10n.dateFormat,
                        readOnly: true,
                        onTap: () =>
                            AppHelpers.selectDate(context, startDateController),
                        suffixIcon: const Icon(Icons.calendar_today_outlined),
                        fillColor: Theme.of(context).colorScheme.surface,
                        borderRadius: AppRadius.radius32.r,
                        validator: AppValidators.required(
                          message: 'Please select a start date.',
                        ),
                      ),
                    ],
                  ),
                ),

                Gap(AppSpacing.space16.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        context.l10n.endDate,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),

                      Gap(AppSpacing.space8.h),

                      AppTextField(
                        controller: endDateController,
                        hintText: context.l10n.dateFormat,
                        readOnly: true,
                        onTap: () =>
                            AppHelpers.selectDate(context, endDateController),
                        suffixIcon: const Icon(Icons.calendar_today_outlined),
                        fillColor: Theme.of(context).colorScheme.surface,
                        borderRadius: AppRadius.radius32.r,
                        validator: AppValidators.required(
                          message: 'Please select an end date.',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Gap(AppSpacing.space16.h),

            Align(
              alignment: AlignmentDirectional.topStart,
              child: AppText(
                context.l10n.reason,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),

            Gap(AppSpacing.space8.h),

            AppTextField(
              controller: reasonController,
              hintText: context.l10n.reasonHint,
              type: AppTextFieldType.multiline,
              fillColor: Theme.of(context).colorScheme.surface,
              borderRadius: AppRadius.radius32.r,
              maxLines: 1,
              validator: AppValidators.required(
                message: 'Please enter a reason.',
              ),
            ),

            Gap(AppSpacing.space20.h),

            GestureDetector(
              onTap: () async {
                final File? image = await AppHelpers.pickImage();

                if (image != null) {
                  setState(() {
                    selectedImage = image;
                  });
                }
              },
              child: AppCard(
                height: 130.h,
                width: double.infinity,
                padding: EdgeInsets.zero,
                backgroundColor: Theme.of(context).colorScheme.surface,
                borderRadius: AppRadius.radius16.r,
                border: Border.all(
                  width: .5.w,
                  color: Theme.of(context).colorScheme.outlineVariant,
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
                            style: Theme.of(context).textTheme.titleSmall,
                          ),

                          Gap(AppSpacing.space4.h),

                          AppText(context.l10n.uploadImage),
                        ],
                      ),
              ),
            ),

            Gap(AppSpacing.space8.h),

            AppButton(
              text: context.l10n.submitRequest,
              onPressed: submitForm,
              height: 48.h,
              width: double.infinity.w,
            ),
          ],
        ),
      ),
    );
  }
}
