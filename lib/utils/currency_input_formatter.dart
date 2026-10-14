import 'dart:math' as math;

import 'package:flutter/services.dart';

/// Formats numeric input with thousands separators while preserving an
/// optional decimal part of up to two digits.
class CurrencyInputFormatter extends TextInputFormatter {
  const CurrencyInputFormatter();

  static final RegExp _validAmount = RegExp(r'^\d*\.?\d{0,2}$');
  static final RegExp _thousands = RegExp(r'(\d)(?=(\d{3})+(?!\d))');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final rawText = newValue.text.replaceAll(',', '');
    if (rawText.isEmpty) return const TextEditingValue();
    if (!_validAmount.hasMatch(rawText)) return oldValue;

    final parts = rawText.split('.');
    final integerPart = parts.first.replaceAllMapped(_thousands, (match) {
      return '${match.group(1)},';
    });
    final formattedText = parts.length == 1
        ? integerPart
        : '$integerPart.${parts.last}';

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection(
        baseOffset: _formattedOffset(
          formattedText,
          _rawOffset(newValue.text, newValue.selection.baseOffset),
        ),
        extentOffset: _formattedOffset(
          formattedText,
          _rawOffset(newValue.text, newValue.selection.extentOffset),
        ),
      ),
    );
  }

  int _rawOffset(String text, int offset) {
    final safeOffset = offset.clamp(0, text.length);
    return text.substring(0, safeOffset).replaceAll(',', '').length;
  }

  int _formattedOffset(String text, int rawOffset) {
    if (rawOffset <= 0) return 0;

    var consumed = 0;
    for (var index = 0; index < text.length; index++) {
      if (text[index] != ',') consumed++;
      if (consumed == rawOffset) return index + 1;
    }
    return math.min(text.length, rawOffset);
  }
}
