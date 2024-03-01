import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:money_mate/services/locales.dart';

class language_setting extends StatefulWidget {
  const language_setting({super.key});

  @override
  State<language_setting> createState() => _language_settingState();
}

class _language_settingState extends State<language_setting> {
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
        title: Text(LocaleData.language_appbar.getString(context)),
      ),
      body: Column(
        children: [
          RadioListTile(
            title: Text(LocaleData.op_vi.getString(context)),
            value: "vi",
            groupValue: current_locale,
            onChanged: (value) {
              set_locale(value!);
            },
          ),
          RadioListTile(
            title: Text(LocaleData.op_en.getString(context)),
            value: "en",
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
    if (value == 'vi') {
      flutter_localization.translate('vi');
    } else if (value == 'en') {
      flutter_localization.translate('en');
    } else {
      return;
    }
    setState(() {
      current_locale = value;
    });
  }
}
