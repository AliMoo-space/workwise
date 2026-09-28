import 'package:flutter/material.dart';

abstract final class AppValidators {
  const AppValidators._();

  static final RegExp _emailRegex = RegExp(
    r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  static final RegExp _strongPasswordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$',
  );

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
    String emptyMessage = 'Email is required.',
    String invalidMessage = 'Enter a valid email address.',
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
    String emptyMessage = 'Password is required.',
    String? minLengthMessage,
    String weakPasswordMessage =
        'Password must contain an uppercase letter, '
        'a lowercase letter, and a number.',
  }) {
    return (value) {
      if (value == null || value.isEmpty) {
        return emptyMessage;
      }

      if (value.length < minLength) {
        return minLengthMessage ??
            'Password must be at least $minLength characters.';
      }

      if (requireStrongPassword &&
          !_strongPasswordRegex.hasMatch(value)) {
        return weakPasswordMessage;
      }

      return null;
    };
  }

  static FormFieldValidator<String> confirmPassword(
    TextEditingController passwordController, {
    String message = 'Passwords do not match.',
    String emptyMessage = 'Password confirmation is required.',
  }) {
    return (value) {
      if (value == null || value.isEmpty) {
        return emptyMessage;
      }

      if (value != passwordController.text) {
        return message;
      }

      return null;
    };
  }

  static FormFieldValidator<String> minLength(
    int length, {
    String? message,
  }) {
    return (value) {
      if (value == null || value.length < length) {
        return message ?? 'Minimum $length characters required.';
      }

      return null;
    };
  }

  static FormFieldValidator<String> maxLength(
    int length, {
    String? message,
  }) {
    return (value) {
      if (value != null && value.length > length) {
        return message ?? 'Maximum $length characters allowed.';
      }

      return null;
    };
  }

  static FormFieldValidator<String> compose(
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
}