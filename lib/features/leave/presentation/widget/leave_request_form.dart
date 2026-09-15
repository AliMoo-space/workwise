import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';
import 'package:workwise/core/design_system/widgets/buttons/app_button.dart';
import 'package:workwise/core/design_system/widgets/inputs/app_dropdown.dart';
import 'package:workwise/core/design_system/widgets/inputs/app_text_field.dart';
import 'package:workwise/core/utils/app_helpers.dart';
import 'package:workwise/generated/app_localizations.dart';

// ignore: must_be_immutable
class LeaveRequestForm extends StatefulWidget {
  const LeaveRequestForm({super.key});

  @override
  State<LeaveRequestForm> createState() => _LeaveRequestFormState();
}

class _LeaveRequestFormState extends State<LeaveRequestForm> {
  File? selectedImage;

  final TextEditingController startDateController = TextEditingController();

  final TextEditingController endDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return SizedBox(
      height: 520.h,
      width: double.infinity,
      child: Card(
        color: Theme.of(context).colorScheme.onError,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.r),
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline,
            width: 1.w,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(15.r),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  localization.leaveType,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),

              Gap(10.h),

              AppDropdown<String>(
                hint: localization.selectLeaveType,
                fillColor: Theme.of(context).colorScheme.surface,
                borderRadius: 30,
                items: [
                  DropdownMenuItem(
                    value: 'Annual Leave',
                    child: Text(localization.annualLeave),
                  ),
                  DropdownMenuItem(
                    value: 'Casual Leave',
                    child: Text(localization.casualLeave),
                  ),
                  DropdownMenuItem(
                    value: 'Sick Leave',
                    child: Text(localization.sickLeave),
                  ),
                ],
                onChanged: (value) {
                  print(value);
                },
              ),

              Gap(15.h),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localization.startDate,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),

                        Gap(10.h),

                        AppTextField(
                          controller: startDateController,
                          hintText: 'DD / MM / YYYY',
                          readOnly: true,
                          onTap: () => AppHelpers.selectDate(
                            context,
                            startDateController,
                          ),
                          suffixIcon: const Icon(Icons.calendar_today_outlined),
                          fillColor: Theme.of(context).colorScheme.surface,
                          borderRadius: 30,
                        ),
                      ],
                    ),
                  ),

                  Gap(16.w),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localization.endDate,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),

                        Gap(10.h),

                        AppTextField(
                          controller: endDateController,
                          hintText: 'DD / MM / YYYY',
                          readOnly: true,
                          onTap: () =>
                              AppHelpers.selectDate(context, endDateController),
                          suffixIcon: const Icon(Icons.calendar_today_outlined),
                          fillColor: Theme.of(context).colorScheme.surface,
                          borderRadius: 30,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Gap(15.h),

              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  localization.reason,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),

              Gap(10.h),

              AppTextField(
                hintText: localization.reasonHint,
                type: AppTextFieldType.multiline,
                fillColor: Theme.of(context).colorScheme.surface,
                borderRadius: 30,
                maxLines: 1,
              ),

              Gap(20.h),

              GestureDetector(
                onTap: () async {
                  final File? image = await AppHelpers.pickImage();

                  if (image != null) {
                    setState(() {
                      selectedImage = image;
                    });
                  }
                },
                child: Container(
                  height: 130.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    border: Border.all(
                      width: .5.w,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(15.r),
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

                            Text(
                              localization.attachSupportingDocument,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),

                            Gap(5.h),

                            Text(localization.uploadImage),
                          ],
                        ),
                ),
              ),

              Gap(10.h),

              AppButton(
                text: localization.submitRequest,
                onPressed: () {},
                height: 48.h,
                width: double.infinity.w,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
