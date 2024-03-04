import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:money_mate/main.dart';
import 'package:money_mate/services/firestore_helper.dart';
import 'package:money_mate/services/locales.dart';
import 'package:money_mate/widget/accounts/login.dart';
import 'package:money_mate/widget/setting/language_setting.dart';
import 'package:money_mate/widget/setting/privacy_setting.dart';

class setting_content extends StatefulWidget {
  const setting_content({super.key});

  @override
  State<setting_content> createState() => _setting_contentState();
}

class _setting_contentState extends State<setting_content> {
  bool is_dark = false;
  late String current_locale;
  final db_helper = firestore_helper();
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final flutter_localization = FlutterLocalization.instance;

  @override
  void initState() {
    get_dark_mode();
    current_locale = flutter_localization.currentLocale!.languageCode;
    super.initState();
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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
            left: width * 0.04,
            top: height * 0.28,
            right: width * 0.04,
            bottom: height * 0.05),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                                    width: width * 0.7,
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
                          const Icon(Icons.navigate_next)
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
                                  width: width * 0.7,
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
            isDestructiveAction: true,
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
