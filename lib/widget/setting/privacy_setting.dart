import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:money_mate/main.dart';
import 'package:money_mate/services/firestore_helper.dart';
import 'package:money_mate/services/locales.dart';
import 'package:money_mate/view_model/setting_view_model.dart';
import 'package:money_mate/widget/auth/login.dart';
import 'package:provider/provider.dart';

class privacy_setting extends StatefulWidget {
  const privacy_setting({super.key});

  @override
  State<privacy_setting> createState() => _privacy_settingState();
}

class _privacy_settingState extends State<privacy_setting> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool is_dark = Theme.of(context).brightness == Brightness.dark;
    return Consumer<setting_view_model>(
      builder: (BuildContext context, setting_vm, Widget? child) {
        setting_vm.toast.init(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(LocaleData.privacy.getString(context)),
          ),
          body: SingleChildScrollView(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(left: 14.0, right: 14),
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  color: is_dark ? Colors.grey[700] : Colors.grey[200],
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      setting_vm.delete_all_data(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 10.0, right: 18),
                            child: Icon(
                              Icons.folder_delete,
                              color: Colors.red,
                              size: 26,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                LocaleData.delete_all_data_acc
                                    .getString(context),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                              Text(
                                LocaleData.delete_all_data_acc_des
                                    .getString(context),
                                style: const TextStyle(color: Colors.grey),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 14.0, right: 14),
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  color: is_dark ? Colors.grey[700] : Colors.grey[200],
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () async {
                      setting_vm.delete_user(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 10.0, right: 18),
                            child: Icon(
                              Icons.person_off,
                              color: Colors.red,
                              size: 26,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                LocaleData.delete_acc.getString(context),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                              Text(
                                LocaleData.delete_acc_des.getString(context),
                                style: const TextStyle(color: Colors.grey),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}
