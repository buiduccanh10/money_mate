import 'package:flutter_localization/flutter_localization.dart';

const List<MapLocale> CURRENCY = [
  MapLocale('vi', CurrencyData.VIC),
  MapLocale('en', CurrencyData.ENC),
];

mixin CurrencyData {
  static const String currency = 'currency';
  static const String vi_currency_op = 'vi_currency_op';
  static const String en_currency_op = 'en_currency_op';

  static const Map<String, dynamic> ENC = {
    currency: 'VNĐ',
    vi_currency_op: 'Viet nam dong'
  };
  static const Map<String, dynamic> VIC = {
    currency: 'Dollar',
    en_currency_op: 'Dollars'
  };
}
