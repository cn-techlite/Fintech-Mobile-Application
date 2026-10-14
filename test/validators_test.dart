import 'package:fintech_mobile_application/utils/currency_input_formatter.dart';
import 'package:fintech_mobile_application/utils/validators.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators', () {
    test('accepts the assessment email', () {
      expect(Validators.email('test@bank.com'), isNull);
    });

    test('rejects an invalid email', () {
      expect(Validators.email('not-an-email'), isNotNull);
    });

    test('requires at least eight password characters', () {
      expect(Validators.password('short'), isNotNull);
      expect(Validators.password('Password123'), isNull);
    });

    test('requires a positive amount', () {
      expect(Validators.positiveAmount('0', label: 'Amount'), isNotNull);
      expect(Validators.positiveAmount('25,000', label: 'Amount'), isNull);
    });
  });

  group('CurrencyInputFormatter', () {
    const formatter = CurrencyInputFormatter();

    test('adds thousands separators', () {
      const value = TextEditingValue(
        text: '1000000.50',
        selection: TextSelection.collapsed(offset: 10),
      );

      final result = formatter.formatEditUpdate(TextEditingValue.empty, value);

      expect(result.text, '1,000,000.50');
      expect(result.selection.baseOffset, result.text.length);
    });

    test('accepts pasted comma-formatted amounts', () {
      const value = TextEditingValue(
        text: '25,000',
        selection: TextSelection.collapsed(offset: 6),
      );

      final result = formatter.formatEditUpdate(TextEditingValue.empty, value);

      expect(result.text, '25,000');
    });
  });
}
