import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';

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

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  Future<void> selectDate(TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      controller.text =
          "${pickedDate.day.toString().padLeft(2, '0')} / "
          "${pickedDate.month.toString().padLeft(2, '0')} / "
          "${pickedDate.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 520.h,
      width: double.infinity,
      child: Card(
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.r),
          side: BorderSide(color: Colors.grey.shade400, width: 1.w),
        ),
        child: Padding(
          padding: EdgeInsets.all(15.r),
          child: Column(
            children: [
              Align(
                alignment: AlignmentGeometry.topLeft,
                child: Text(
                  "Leave type",
                  style: TextStyle(
                    fontSize: 17,
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Gap(10.h),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  hintText: "Select type...",
                  filled: true,
                  fillColor: AppColors.background,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.r),
                    borderSide: BorderSide(
                      color: AppColors.border,
                      width: .5.w,
                    ),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.r),
                    borderSide: BorderSide(
                      color: AppColors.border,
                      width: .5.w,
                    ),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: Colors.grey.shade600,
                      width: 1.w,
                    ),
                  ),
                ),

                borderRadius: BorderRadius.circular(15.r),
                dropdownColor: AppColors.white,
                menuMaxHeight: 200.h,

                items: const [
                  DropdownMenuItem(
                    value: "Annual Leave",
                    child: Text("Annual Leave"),
                  ),
                  DropdownMenuItem(
                    value: "Casual Leave",
                    child: Text("Casual Leave"),
                  ),
                  DropdownMenuItem(
                    value: "sick Leave",
                    child: Text("Sick Leave"),
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
                          "Start date",
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Gap(10.h),
                        TextField(
                          controller: startDateController,
                          readOnly: true,
                          onTap: () => selectDate(startDateController),
                          decoration: InputDecoration(
                            hintText: "DD / MM / YYYY",
                            hintStyle: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.black,
                            ),
                            filled: true,
                            fillColor: AppColors.background,

                            suffixIcon: Icon(
                              Icons.calendar_today_outlined,
                              size: 20.r,
                            ),

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.r),
                              borderSide: BorderSide(
                                color: AppColors.border,
                                width: .5.w,
                              ),
                            ),

                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.r),
                              borderSide: BorderSide(
                                color: AppColors.border,
                                width: .5.w,
                              ),
                            ),

                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.r),
                              borderSide: BorderSide(
                                color: Colors.grey.shade600,
                                width: 1.w,
                              ),
                            ),
                          ),
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
                          "End date",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Gap(10.h),
                        TextField(
                          controller: endDateController,
                          readOnly: true,
                          onTap: () => selectDate(endDateController),
                          decoration: InputDecoration(
                            hintText: "DD / MM / YYYY",
                            hintStyle: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.black,
                            ),
                            filled: true,
                            fillColor: AppColors.background,

                            suffixIcon: Icon(
                              Icons.calendar_today_outlined,
                              size: 20.r,
                            ),

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.r),
                              borderSide: BorderSide(
                                color: AppColors.border,
                                width: .5.w,
                              ),
                            ),

                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.r),
                              borderSide: BorderSide(
                                color: AppColors.border,
                                width: .5.w,
                              ),
                            ),

                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.r),
                              borderSide: BorderSide(
                                color: Colors.grey.shade600,
                                width: 1.w,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Gap(15.h),

              Align(
                alignment: AlignmentGeometry.topLeft,
                child: Text(
                  "Reason",
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              Gap(10.h),
              TextField(
                decoration: InputDecoration(
                  hintText: "Briefly describe your reason...",
                  filled: true,

                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.r),
                    borderSide: BorderSide(
                      color: AppColors.border,
                      width: .5.w,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.r),
                    borderSide: BorderSide(
                      color: AppColors.border,
                      width: .5.w,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.r),
                    borderSide: BorderSide(color: AppColors.border, width: 1.w),
                  ),
                ),
              ),

              Gap(20.h),
              GestureDetector(
                onTap: pickImage,
                child: Container(
                  height: 130.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    border: Border.all(width: .5.w, color: AppColors.border),
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
                            Icon(Icons.cloud_upload),
                            Text(
                              "Attach supporting document",
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Gap(5.h),
                            Text("Upload image"),
                          ],
                        ),
                ),
              ),

              Gap(10.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff243B53),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 100.w,
                    vertical: 13.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  "Submit request",
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
