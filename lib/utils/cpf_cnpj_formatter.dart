import 'package:flutter/services.dart';

class CpfCnpjInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    String formattedText;

    if (text.length > 11) {
      // Formato CNPJ
      const maxLength = 14;
      final truncatedText =
          text.length > maxLength ? text.substring(0, maxLength) : text;
      formattedText = _formatCnpj(truncatedText);
    } else {
      // Formato CPF
      const maxLength = 11;
      final truncatedText =
          text.length > maxLength ? text.substring(0, maxLength) : text;
      formattedText = _formatCpf(truncatedText);
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }

  String _formatCpf(String text) {
    var masked = '';
    for (var i = 0; i < text.length; i++) {
      if (i == 3 || i == 6) {
        masked += '.';
      } else if (i == 9) {
        masked += '-';
      }
      masked += text[i];
    }
    return masked;
  }

  String _formatCnpj(String text) {
    var masked = '';
    for (var i = 0; i < text.length; i++) {
      if (i == 2 || i == 5) {
        masked += '.';
      } else if (i == 8) {
        masked += '/';
      } else if (i == 12) {
        masked += '-';
      }
      masked += text[i];
    }
    return masked;
  }
}

