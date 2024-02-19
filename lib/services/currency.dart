import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Currency extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    double value = double.parse(newValue.text);
    final money = NumberFormat("###,###,###", "vi_VN");

    String new_text = money.format(value);

    return newValue.copyWith(
        text: new_text,
        selection: TextSelection.collapsed(offset: new_text.length));
  }
}
