import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:money_mate/services/currency_format.dart';
import 'package:money_mate/services/firestore_helper.dart';
import 'package:money_mate/services/locales.dart';
import 'package:money_mate/widget/setting/advance_setting/start_setup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class setup_in_ex_regular extends StatefulWidget {
  static final setup_in_ex_regular_globalkey =
      GlobalKey<_setup_in_ex_regularState>();

  static _setup_in_ex_regularState? getState() {
    return setup_in_ex_regular_globalkey.currentState;
  }

  setup_in_ex_regular()
      : super(key: setup_in_ex_regular.setup_in_ex_regular_globalkey);

  @override
  State<setup_in_ex_regular> createState() => _setup_in_ex_regularState();
}

class _setup_in_ex_regularState extends State<setup_in_ex_regular> {
  List<Map<String, dynamic>> data = [];
  bool is_loading = true;
  bool is_mounted = false;
  FToast toast = FToast();
  firestore_helper db_helper = firestore_helper();
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final localization = FlutterLocalization.instance;

  @override
  void initState() {
    fetch_data_shared_preferences();
    is_mounted = true;
    super.initState();
  }

  Future<void> fetch_data_shared_preferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('translator_locale_key');
    Set<String> keys = prefs.getKeys();

    if (keys.isNotEmpty) {
      for (String key in keys) {
        final inputData = prefs.getStringList(key);

        String uid = inputData![0];
        String date = inputData[1];
        String description = inputData[2];
        double money = double.parse(inputData[3]);
        String cat_id = inputData[4];

        Map<String, dynamic> content = {
          'id': key,
          'uid': uid,
          'date': date,
          'description': description,
          'money': money,
          'cat_id': cat_id,
        };
        if (is_mounted) {
          setState(() {
            data.add(content);
            is_loading = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    is_mounted = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool is_dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleData.fixed_in_ex.getString(context)),
        actions: [
          IconButton(
              onPressed: () {
                delete_all_schedule();
              },
              icon: const Icon(
                Icons.delete_sweep,
                color: Colors.red,
              ))
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          data.isEmpty
              ? Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.35),
                  child: Center(
                      child: Text(
                    LocaleData.no_set_up_yet.getString(context),
                    style: const TextStyle(fontSize: 18),
                  )),
                )
              : is_loading
                  ? ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100),
                      itemCount: 10,
                      itemBuilder: (BuildContext context, int index) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, left: 24, right: 24),
                            child: ListTile(
                              title: Container(
                                height: 20,
                                color: Colors.white,
                              ),
                              subtitle: Container(
                                height: 15,
                                color: Colors.white,
                              ),
                              leading: Container(
                                width: 50,
                                height: 50,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              trailing: Container(
                                width: 60,
                                height: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : SizedBox(
                      height: 500,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 0),
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, index) {
                          return Slidable(
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  backgroundColor: Colors.transparent,
                                  onPressed: (context) {
                                    handle_delete(
                                        int.parse(data[index]['id']), index);
                                  },
                                  foregroundColor: Colors.red,
                                  icon: Icons.delete,
                                  label: LocaleData.slide_delete
                                      .getString(context),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 14, bottom: 14, left: 24, right: 24),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      // Container(
                                      //   decoration: BoxDecoration(
                                      //       boxShadow: is_dark
                                      //           ? null
                                      //           : [
                                      //               BoxShadow(
                                      //                 color: Colors.grey
                                      //                     .withOpacity(0.3),
                                      //                 spreadRadius: 2,
                                      //                 blurRadius: 7,
                                      //                 offset:
                                      //                     const Offset(-5, 5),
                                      //               )
                                      //             ],
                                      //       borderRadius:
                                      //           BorderRadius.circular(50)),
                                      //   child: CircleAvatar(
                                      //       backgroundColor: Colors
                                      //           .primaries[Random().nextInt(
                                      //               Colors.primaries.length)]
                                      //           .shade100
                                      //           .withOpacity(0.35),
                                      //       radius: 28,
                                      //       child: Text(
                                      //         data[index]['icon'],
                                      //         style: const TextStyle(
                                      //             fontSize: 38),
                                      //       )),
                                      // ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              // width: width * 0.4,
                                              child: Text(
                                                data[index]['description'],
                                                softWrap: true,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                            Text(
                                              data[index]['date'],
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.grey),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        // '${data[index]['is_income'] ? '+' : '-'} ${format_money}',
                                        '${data[index]['money']}',
                                        // style: TextStyle(
                                        //     fontSize: 14,
                                        //     fontWeight: FontWeight.w700,
                                        //     color: data[index]['is_income']
                                        //         ? Colors.green
                                        //         : Colors.red),
                                      ),
                                      // Text(
                                      //   data[index]['name'],
                                      //   style: const TextStyle(
                                      //       fontSize: 16,
                                      //       fontWeight: FontWeight.w700,
                                      //       color: Colors.grey),
                                      // )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
        ],
      )),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 15),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (builder) => const start_setup()));
          },
          backgroundColor: const Color.fromARGB(255, 63, 148, 66),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 35,
          ),
        ),
      ),
    );
  }

  void handle_delete(int input_id, int index) async {
    try {
      db_helper.removeScheduleInputTask(input_id);
      setState(() {
        data.removeAt(index);
      });

      toast.showToast(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.green,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(Icons.check),
              Text(LocaleData.toast_delete_success.getString(context)),
            ],
          ),
        ),
        gravity: ToastGravity.CENTER,
        toastDuration: const Duration(seconds: 2),
      );
    } catch (err) {
      toast.showToast(
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
              Text(LocaleData.toast_delete_fail.getString(context)),
            ],
          ),
        ),
        gravity: ToastGravity.CENTER,
        toastDuration: const Duration(seconds: 2),
      );
    }
  }

  void delete_all_schedule() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(LocaleData.delete_all_schedule.getString(context)),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  LocaleData.cancel.getString(context),
                ),
              ),
              CupertinoDialogAction(
                  isDestructiveAction: true,
                  onPressed: () {
                    db_helper.removeAllSchedule;
                    setState(() {
                      data.clear();
                    });
                    toast.showToast(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.green,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Icon(Icons.check),
                            Text(LocaleData.toast_delete_success
                                .getString(context)),
                          ],
                        ),
                      ),
                      gravity: ToastGravity.CENTER,
                      toastDuration: const Duration(seconds: 2),
                    );
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    LocaleData.confirm.getString(context),
                  )),
            ],
          );
        });
  }
}
