import 'package:intl/intl.dart';

import '../constants/text_strings.dart';

class TValidator {
  static String? validateEmptyText(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required.';
    }

    return null;
  }

  static String? validatePinCode(String? pinCode) {
    if (pinCode == null || pinCode.isEmpty) {
      return 'Pin Code is required.';
    }

    if (pinCode.length < 6) {
      return 'Pin Code must be 6 Digits.';
    }

    return null;
  }

  static String? validateAge(String? input) {
    if (input == null || input.isEmpty) {
      return 'Date of Birth is required.';
    }

    try {
      final DateFormat format = DateFormat('dd-MMM-yyyy');
      final DateTime dateOfBirth = format.parse(input);

      final DateTime today = DateTime.now();
      final int age =
          today.year - dateOfBirth.year - ((today.month < dateOfBirth.month || (today.month == dateOfBirth.month && today.day < dateOfBirth.day)) ? 1 : 0);

      if (age < 18) {
        return AppTexts.dateOfBirthError;
      }
    } catch (e) {
      return 'Invalid date format. Use dd-MMM-yyyy.';
    }

    return null;
  }

  /// Username Validation
  static String? validateUsername(String? username) {
    if (username == null || username.isEmpty) {
      return 'Username is required.';
    }

    const pattern = r"^[a-zA-Z0-9_-]{3,20}$";

    final regex = RegExp(pattern);

    bool isValid = regex.hasMatch(username);

    if (isValid) {
      isValid = !username.startsWith('_') && !username.startsWith('-') && !username.endsWith('_') && !username.endsWith('-');
    }

    if (!isValid) {
      return 'Username is not valid.';
    }

    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required.';
    }

    final emailRegExp = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)) {
      return 'Invalid email address.';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters long.';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter.';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number.';
    }

    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character.';
    }

    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required.';
    }

    final returnValue = validatePhoneNumberFormat(value);

    return returnValue;
  }

  static String? validatePhoneNumberFormat(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    final phoneRegExp = RegExp(r'^\d{10}$');

    if (!phoneRegExp.hasMatch(value)) {
      return 'Invalid phone number format (10 digits required).';
    }

    return null;
  }

}
