import 'package:email_validator/email_validator.dart';

abstract final class Validators {
  static String? requiredField(String? value, {String label = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$label is required.';
    }
    return null;
  }

  static String? email(String? value) {
    final requiredError = requiredField(value, label: 'Email');
    if (requiredError != null) return requiredError;
    if (!EmailValidator.validate(value!.trim())) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  static String? password(String? value) {
    final requiredError = requiredField(value, label: 'Password');
    if (requiredError != null) return requiredError;
    if (value!.length < 8) return 'Password must be at least 8 characters.';
    return null;
  }

  static String? positiveAmount(String? value, {required String label}) {
    final requiredError = requiredField(value, label: label);
    if (requiredError != null) return requiredError;
    final amount = double.tryParse(value!.replaceAll(',', '').trim());
    if (amount == null || amount <= 0) return 'Enter a valid amount.';
    return null;
  }
}
