import 'package:flutter/material.dart';

final class AppValidators {
  const AppValidators._();

  // ===========================
  // Regex
  // ===========================

  static final RegExp _emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
  static final RegExp _passwordRegex =
      RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');













//may remove
  // static final RegExp _phoneRegex = RegExp(r'^\d{11}$');

  // static final RegExp _uppercaseRegex = RegExp(r'[A-Z]');
  // static final RegExp _lowercaseRegex = RegExp(r'[a-z]');
  // static final RegExp _numberRegex = RegExp(r'\d');

  // ===========================
  // Basic
  // ===========================

  static FormFieldValidator<String> required({
    String message = 'This field is required.',
  }) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return message;
      }

      return null;
    };
  }

  static FormFieldValidator<String> email({
    String emptyMessage = 'البريد الإلكتروني مطلوب.',
    // 'Email is required.',
    String invalidMessage = 'أدخل عنوان بريد إلكتروني صالح.',
    // 'Enter a valid email address.',
  }) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return emptyMessage;
      }

      if (!_emailRegex.hasMatch(value.trim())) {
        return invalidMessage;
      }

      return null;
    };
  }



static FormFieldValidator<String> password({
    int minLength = 8,
    bool requireStrongPassword = false,
    String emptyMessage = 'كلمة المرور مطلوبة.',
    String? minLengthMessage,
    String weakPasswordMessage =
        'كلمة المرور يجب أن تحتوي على حرف كبير، حرف صغير، ورقم.',
  }) 
  {
    return (value) {
      if (value == null || value.isEmpty) {
        return emptyMessage;
      }

      if (value.length < minLength) {
        return minLengthMessage ??
            'كلمة المرور يجب أن تكون على الأقل $minLength أحرف.';
      }

      if (requireStrongPassword && !_passwordRegex.hasMatch(value)) {
        return weakPasswordMessage;
      }

      return null; 
    };
  }
 static FormFieldValidator<String> confirmPassword(
    TextEditingController passwordController, {
    String message = 'كلمة المرور غير متطابقة.',
  }) {
    return (value) {
      if (value == null || value.isEmpty) {
        return 'تأكيد كلمة المرور مطلوب.';
      }
      if (value != passwordController.text) {
        return message;
      }
      return null;
    };
  }
}








































  // may remove

  // static FormFieldValidator<String> phone({
  //   String emptyMessage = 'رقم الهاتف مطلوب.',
  //   // 'Phone number is required.',
  //   String invalidMessage = 'أدخل رقم هاتف صالح.',
  //   // 'Enter a valid phone number.',
  // }) {
  //   return (value) {
  //     if (value == null || value.trim().isEmpty) {
  //       return emptyMessage;
  //     }

  //     if (!_phoneRegex.hasMatch(value.trim())) {
  //       return invalidMessage;
  //     }

  //     return null;
  //   };
  // }

  // static FormFieldValidator<String> password({int minLength = 7}) {
  //   return (value) {
  //     if (value == null || value.isEmpty) {
  //       return 'كلمة المرور مطلوبة.';
  //       // 'Password is required.';
  //     }

  //     if (value.length < minLength) {
  //       return 'كلمة المرور يجب أن تكون على الأقل $minLength أحرف.';
  //       // 'Password must be at least $minLength characters.';
  //     }

  //     if (!_uppercaseRegex.hasMatch(value)) {
  //       return 'كلمة المرور يجب أن تحتوي على حرف كبير.';
  //       // 'Password must contain an uppercase letter.';
  //     }

  //     if (!_lowercaseRegex.hasMatch(value)) {
  //       return 'كلمة المرور يجب أن تحتوي على حرف صغير.';
  //       // 'Password must contain a lowercase letter.';
  //     }

  //     if (!_numberRegex.hasMatch(value)) {
  //       return 'كلمة المرور يجب أن تحتوي على رقم.';
  //       // 'Password must contain a number.';
  //     }

  //     return null;
  //   };
  // }

  // ===========================
  // Generic
  // ===========================

   FormFieldValidator<String> minLength(int length, {String? message}) {
    return (value) {
      if (value == null || value.length < length) {
        return message ?? 'وجب أن يكون الحد الأدنى لطول $length حرفًا.';
        // message ?? 'Minimum $length characters required.';
      }

      return null;
    };
  }

   FormFieldValidator<String> maxLength(int length, {String? message}) {
    return (value) {
      if (value != null && value.length > length) {
        return message ?? 'يجب ألا يزيد الحد الأقصى للطول عن $length حرفًا.';
        // message ?? 'Maximum $length characters allowed.';
      }

      return null;
    };
  }

   FormFieldValidator<String> confirmPassword(
    TextEditingController passwordController, {
    String message = 'كلمة المرور غير متطابقة.',
    // 'Passwords do not match.',
  }) {
    return (value) {
      if (value != passwordController.text) {
        return message;
      }

      return null;
    };
  }

   FormFieldValidator<String> compose(
    List<FormFieldValidator<String>> validators,
  ) {
    return (value) {
      for (final validator in validators) {
        final result = validator(value);

        if (result != null) {
          return result;
        }
      }

      return null;
    };
  }

