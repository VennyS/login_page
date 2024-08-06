import 'dart:math';

import 'package:flutter/services.dart';

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text
        .replaceAll(RegExp(r'\D'), ''); // Удаление всех нецифровых символов

    if (text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final buffer = StringBuffer();

    // Форматируем текст в виде (XXX) XXX-XX-XX
    if (text.isNotEmpty) {
      buffer.write('(');
      buffer.write(text.substring(0, min(3, text.length)));
      buffer.write(')');
    }
    if (text.length > 3) {
      buffer.write(' ');
      buffer.write(text.substring(3, min(6, text.length)));
    }
    if (text.length > 6) {
      buffer.write('-');
      buffer.write(text.substring(6, min(8, text.length)));
    }
    if (text.length > 8) {
      buffer.write('-');
      buffer.write(text.substring(8, min(10, text.length)));
    }

    return newValue.copyWith(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
