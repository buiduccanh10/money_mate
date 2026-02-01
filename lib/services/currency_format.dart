import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class CurrencyFormat {
  static CurrencyTextInputFormatter getFormatter(String locale) {
    int decimalDigits = 2;
    if (locale.startsWith('vi')) {
      decimalDigits = 0;
    }

    return CurrencyTextInputFormatter.currency(
      locale: locale,
      decimalDigits: decimalDigits,
      enableNegative: false,
    );
  }
}
