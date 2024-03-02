import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:money_mate/services/currency.dart';
import 'package:money_mate/services/locales.dart';

class currency_setting extends StatefulWidget {
  const currency_setting({super.key});

  @override
  State<currency_setting> createState() => _currency_settingState();
}

class _currency_settingState extends State<currency_setting> {
  late String current_locale;
  final flutter_localization = FlutterLocalization.instance;

  @override
  void initState() {
    current_locale = flutter_localization.currentLocale!.languageCode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(CurrencyData.currency.getString(context)),
      ),
      body: Column(
        children: [
          RadioListTile(
            title: Text(CurrencyData.vi_currency_op.getString(context)),
            value: "VI",
            groupValue: current_locale,
            onChanged: (value) {
              set_locale(value!);
            },
          ),
          RadioListTile(
            title: Text(CurrencyData.en_currency_op.getString(context)),
            value: "EN",
            groupValue: current_locale,
            onChanged: (value) {
              set_locale(value!);
            },
          ),
        ],
      ),
    );
  }

  void set_locale(String value) {
    if (value == 'VI') {
      flutter_localization.translate('VI');
    } else if (value == 'EN') {
      flutter_localization.translate('EN');
    } else {
      return;
    }
    setState(() {
      current_locale = value;
    });
  }
}
