import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:money_mate/main.dart';
import 'package:money_mate/services/firestore_helper.dart';
import 'package:money_mate/services/locales.dart';
import 'package:money_mate/widget/accounts/login.dart';

class privacy_setting extends StatefulWidget {
  const privacy_setting({super.key});

  @override
  State<privacy_setting> createState() => _privacy_settingState();
}

class _privacy_settingState extends State<privacy_setting> {
  final db_helper = firestore_helper();
  final uid = FirebaseAuth.instance.currentUser!.uid;
  FToast? toast;

  @override
  void initState() {
    toast = FToast();
    toast!.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool is_dark = Theme.of(context).brightness == Brightness.dark;
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
                  delete_all_data();
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
                            LocaleData.delete_all_data_acc.getString(context),
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
                  delete_user();
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
  }

  void delete_all_data() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:
                Text('${LocaleData.delete_all_data_acc.getString(context)} ?'),
            actions: [
              Container(
                width: 100,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: TextButton(
                    onPressed: () async {
                      try {
                        await db_helper
                            .delete_all_data(uid)
                            .then((value) => toast!.showToast(
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.green,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Icon(Icons.check),
                                        Text(LocaleData.toast_delete_success
                                            .getString(context)),
                                      ],
                                    ),
                                  ),
                                  gravity: ToastGravity.CENTER,
                                  toastDuration: const Duration(seconds: 2),
                                ))
                            .then((value) => Navigator.of(context).pop());
                      } catch (err) {
                        toast!.showToast(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.red,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Icon(Icons.do_disturb),
                                Text(LocaleData.toast_delete_fail
                                    .getString(context)),
                              ],
                            ),
                          ),
                          gravity: ToastGravity.CENTER,
                          toastDuration: const Duration(seconds: 2),
                        );
                      }
                    },
                    child: Text(
                      LocaleData.confirm.getString(context),
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 127, 127, 127)),
                    )),
              ),
              Container(
                width: 90,
                decoration: BoxDecoration(
                    color: Colors.red,
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(10)),
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      LocaleData.cancel.getString(context),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    )),
              )
            ],
          );
        });
  }

  void delete_user() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('${LocaleData.delete_acc.getString(context)} ?'),
            actions: [
              Container(
                width: 100,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: TextButton(
                    onPressed: () async {
                      try {
                        await db_helper.delete_user(uid).then((value) =>
                            FirebaseAuth.instance
                                .signOut()
                                .then((value) => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const MyApp()),
                                    )));
                      } catch (err) {
                        toast!.showToast(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.red,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Icon(Icons.person_off_outlined),
                                Text(LocaleData.toast_delete_user_fail
                                    .getString(context)),
                              ],
                            ),
                          ),
                          gravity: ToastGravity.CENTER,
                          toastDuration: const Duration(seconds: 4),
                        );
                      }
                    },
                    child: Text(
                      LocaleData.confirm.getString(context),
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 127, 127, 127)),
                    )),
              ),
              Container(
                width: 90,
                decoration: BoxDecoration(
                    color: Colors.red,
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(10)),
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      LocaleData.cancel.getString(context),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    )),
              )
            ],
          );
        });
  }
}
