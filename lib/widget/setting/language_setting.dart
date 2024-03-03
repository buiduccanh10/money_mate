import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:money_mate/services/firestore_helper.dart';
import 'package:money_mate/services/locales.dart';

class language_setting extends StatefulWidget {
  const language_setting({super.key});

  @override
  State<language_setting> createState() => _language_settingState();
}

class _language_settingState extends State<language_setting> {
  late String current_locale;
  final flutter_localization = FlutterLocalization.instance;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final db_helper = firestore_helper();

  @override
  void initState() {
    get_language();
    current_locale = flutter_localization.currentLocale!.languageCode;
    super.initState();
  }

  Future<void> get_language() async {
    String temp = (await db_helper.get_language(uid))!;
    setState(() {
      current_locale = temp;
      set_locale(current_locale);
    });
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
          RadioListTile(
            title: Text(LocaleData.op_cn.getString(context)),
            value: "zh",
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
    } else if (value == 'zh') {
      flutter_localization.translate('zh');
    } else {
      return;
    }
    setState(() {
      current_locale = value;
      update_language(uid, current_locale);
    });
  }

  Future<void> update_language(String uid, String language) async {
    await db_helper.update_language(uid, language);
  }
}
