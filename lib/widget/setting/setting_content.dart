import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';
import 'package:money_mate/main.dart';
import 'package:money_mate/services/firestore_helper.dart';
import 'package:money_mate/services/locales.dart';
import 'package:money_mate/widget/accounts/login.dart';
import 'package:money_mate/widget/setting/advance_setting/advance_setting.dart';
import 'package:money_mate/widget/setting/language_setting.dart';
import 'package:money_mate/widget/setting/privacy_setting.dart';

class setting_content extends StatefulWidget {
  const setting_content({super.key});

  @override
  State<setting_content> createState() => _setting_contentState();
}

class _setting_contentState extends State<setting_content> {
  bool is_dark = false;
  bool is_lock = false;
  late String current_locale;
  final db_helper = firestore_helper();
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final flutter_localization = FlutterLocalization.instance;
  final LocalAuthentication local_auth = LocalAuthentication();
  FToast toast = FToast();

  @override
  void initState() {
    get_dark_mode();
    get_is_lock();
    current_locale = flutter_localization.currentLocale!.languageCode;
    super.initState();
  }

  Future<void> get_is_lock() async {
    bool temp = (await db_helper.get_is_lock(uid))!;
    setState(() {
      is_lock = temp;
    });
  }

  Future<void> get_dark_mode() async {
    bool temp = (await db_helper.get_dark_mode(uid))!;
    setState(() {
      is_dark = temp;
      update_theme();
    });
  }

  @override
  Widget build(BuildContext context) {
    toast.init(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
            left: width * 0.04,
            top: 250,
            right: width * 0.04,
            bottom: height * 0.15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(top: 0.0, bottom: 16),
            child: Material(
              color: is_dark ? Colors.grey[700] : Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => const advance_setting()));
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 18),
                            child: Icon(
                              Icons.settings_suggest,
                              color: is_dark ? Colors.brown[100] : Colors.brown,
                              size: 30,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                LocaleData.advanced_settings.getString(context),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Icon(Icons.navigate_next)
                    ],
                  ),
                ),
              ),
            ),
          ),
          Material(
            color: is_dark ? Colors.grey[700] : Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
            child: Column(children: [
              InkWell(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const language_setting()));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 10.0, right: 18),
                            child: Icon(
                              Icons.language,
                              color: Colors.blue,
                              size: 26,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                LocaleData.language.getString(context),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                              Text(
                                LocaleData.language_des.getString(context),
                                style: const TextStyle(color: Colors.grey),
                              )
                            ],
                          ),
                        ],
                      ),
                      const Icon(Icons.navigate_next)
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 18),
                          child: Icon(
                            Icons.dark_mode,
                            color: Colors.purple[700],
                            size: 26,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LocaleData.appearance.getString(context),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                            Text(
                              is_dark
                                  ? LocaleData.darkmode_dark_des
                                      .getString(context)
                                  : LocaleData.darkmode_light_des
                                      .getString(context),
                              style: const TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                      ],
                    ),
                    Switch(
                        value: is_dark,
                        inactiveThumbColor: Colors.orange,
                        inactiveTrackColor: Colors.amber[200],
                        thumbIcon: MaterialStateProperty.resolveWith<Icon?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return const Icon(Icons.dark_mode_outlined);
                            }
                            return const Icon(Icons.light_mode_outlined);
                          },
                        ),
                        onChanged: (value) {
                          setState(() {
                            is_dark = value;
                            update_dark_mode(uid, is_dark);
                            update_theme();
                          });
                        })
                  ],
                ),
              )
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: Material(
              color: is_dark ? Colors.grey[700] : Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
              child: Column(
                children: [
                  InkWell(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 10.0, right: 18),
                                child: Icon(
                                  Icons.lock,
                                  color: Colors.green,
                                  size: 26,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    LocaleData.application_lock
                                        .getString(context),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                  SizedBox(
                                    width: width * 0.6,
                                    child: Text(
                                      LocaleData.application_lock_des
                                          .getString(context),
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Switch(
                              value: is_lock,
                              activeColor: Colors.lightGreen,
                              thumbIcon:
                                  MaterialStateProperty.resolveWith<Icon?>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return const Icon(Icons.check);
                                  }
                                  return const Icon(Icons.close);
                                },
                              ),
                              onChanged: (value) async {
                                if (await local_auth.isDeviceSupported()) {
                                  setState(() {
                                    is_lock = value;
                                    update_is_lock(uid, is_lock);
                                    if (Main.getState() != null) {
                                      Main.getState()!.get_is_lock();
                                    }
                                  });
                                } else {
                                  toast.showToast(
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: Colors.orange,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Icon(Icons.warning),
                                          Flexible(
                                            child: Text(
                                              LocaleData.local_auth_warning
                                                  .getString(context),
                                              overflow: TextOverflow.clip,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    gravity: ToastGravity.CENTER,
                                    toastDuration: const Duration(seconds: 3),
                                  );
                                }
                              })
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const privacy_setting()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 10.0, right: 18),
                                child: Icon(
                                  Icons.privacy_tip,
                                  color: Colors.red,
                                  size: 26,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    LocaleData.privacy.getString(context),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    LocaleData.privacy_des.getString(context),
                                    style: const TextStyle(color: Colors.grey),
                                  )
                                ],
                              ),
                            ],
                          ),
                          const Icon(Icons.navigate_next)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: Material(
              color: is_dark ? Colors.grey[700] : Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
              child: Column(children: [
                InkWell(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  onTap: () {
                    showAboutDialog(context: context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 10.0, right: 18),
                              child: Icon(
                                Icons.info,
                                color: Colors.orange,
                                size: 26,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  LocaleData.about.getString(context),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                                Text(
                                  LocaleData.about_des.getString(context),
                                  style: const TextStyle(color: Colors.grey),
                                )
                              ],
                            ),
                          ],
                        ),
                        const Icon(Icons.navigate_next)
                      ],
                    ),
                  ),
                ),
                InkWell(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 10.0, right: 18),
                              child: Icon(
                                Icons.feedback,
                                size: 26,
                                color: Colors.cyan,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  LocaleData.send_feedback.getString(context),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                                SizedBox(
                                  width: width * 0.6,
                                  child: Text(
                                    LocaleData.send_feedback_des
                                        .getString(context),
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        const Icon(Icons.navigate_next)
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 28.0),
            child: Material(
              color: is_dark ? Colors.grey[700] : Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  show_curpetino_action(context);
                },
                child: SizedBox(
                  height: 50,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              LocaleData.log_out.getString(context),
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  color:
                                      is_dark ? Colors.redAccent : Colors.red),
                            ),
                          ],
                        ),
                      ]),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Future<void> update_dark_mode(String uid, bool is_dark) async {
    await db_helper.update_dark_mode(uid, is_dark);
  }

  Future<void> update_is_lock(String uid, bool is_lock) async {
    await db_helper.update_is_lock(uid, is_lock);
  }

  void update_theme() {
    if (is_dark) {
      MyApp.setAppTheme(context, ThemeData.dark());
    } else {
      MyApp.setAppTheme(context, ThemeData.light());
    }
  }

  void show_curpetino_action(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(
          LocaleData.log_out_dialog.getString(context),
          style: const TextStyle(fontSize: 16),
        ),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () async {
              await FirebaseAuth.instance
                  .signOut()
                  .then((value) => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MyApp()),
                      ));
            },
            child: Text(LocaleData.log_out.getString(context)),
          ),
          CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(LocaleData.cancel.getString(context)),
          ),
        ],
      ),
    );
  }
}
