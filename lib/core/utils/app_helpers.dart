import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AppHelpers {
  static Future<File?> pickImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      return File(image.path);
    }

    return null;
  }

  static Future<void> selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      controller.text =
          '${pickedDate.day.toString().padLeft(2, '0')} / '
          '${pickedDate.month.toString().padLeft(2, '0')} / '
          '${pickedDate.year}';
    }
  }
}
