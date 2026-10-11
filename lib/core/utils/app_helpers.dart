import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

final class AppHelpers {
  const AppHelpers._();

  static Future<File?> pickImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      return null;
    }

    return File(image.path);
  }

  static Future<void> selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final now = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) {
      return;
    }

    final String year = pickedDate.year.toString();
    final String month = pickedDate.month.toString().padLeft(2, '0');
    final String day = pickedDate.day.toString().padLeft(2, '0');

    controller.text = '$year-$month-$day';
  }
}
