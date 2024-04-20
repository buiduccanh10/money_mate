import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:money_mate/services/firestore_helper.dart';
import 'package:money_mate/services/locales.dart';
import 'package:money_mate/view_model/setting_view_model.dart';
import 'package:provider/provider.dart';

class language_setting extends StatefulWidget {
  const language_setting({super.key});

  @override
  State<language_setting> createState() => _language_settingState();
}

class _language_settingState extends State<language_setting> {
  @override
  void initState() {
    var setting_vm = Provider.of<setting_view_model>(context, listen: false);
    setting_vm.init(context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<setting_view_model>(
      builder: (BuildContext context, setting_vm, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(LocaleData.language_appbar.getString(context)),
          ),
          body: Column(
            children: [
              RadioListTile(
                title: Text(LocaleData.op_vi.getString(context)),
                value: "vi",
                groupValue: setting_vm.current_locale,
                onChanged: (value) {
                  setting_vm.set_locale(value!);
                },
              ),
              RadioListTile(
                title: Text(LocaleData.op_en.getString(context)),
                value: "en",
                groupValue: setting_vm.current_locale,
                onChanged: (value) {
                  setting_vm.set_locale(value!);
                },
              ),
              RadioListTile(
                title: Text(LocaleData.op_cn.getString(context)),
                value: "zh",
                groupValue: setting_vm.current_locale,
                onChanged: (value) {
                  setting_vm.set_locale(value!);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
