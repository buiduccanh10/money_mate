import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:money_mate/services/firestore_helper.dart';
import 'package:money_mate/services/locales.dart';
import 'package:money_mate/widget/category/cat_add_dialog.dart';
import 'package:money_mate/widget/category/cat_update_dialog.dart';
import 'package:money_mate/widget/input/input_content.dart';
import 'package:shimmer/shimmer.dart';

class category_manage extends StatefulWidget {
  bool is_income;
  static final category_manage_globalkey = GlobalKey<_category_manageState>();

  static _category_manageState? getState() {
    return category_manage_globalkey.currentState;
  }

  category_manage({required this.is_income})
      : super(key: category_manage.category_manage_globalkey);

  @override
  State<category_manage> createState() => _category_manageState();
}

class _category_manageState extends State<category_manage> {
  List<Map<String, dynamic>> data = [];
  firestore_helper db_helper = firestore_helper();
  bool is_loading = true;
  bool is_mounted = false;
  FToast toast = FToast();
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    is_mounted = true;
    fetch_data();
    super.initState();
  }

  @override
  void dispose() {
    is_mounted = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    toast.init(context);
    bool is_dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 15),
        child: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return cat_add_dialog(
                    is_income: widget.is_income,
                  );
                });
          },
          backgroundColor: const Color.fromARGB(255, 63, 148, 66),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 35,
          ),
        ),
      ),
      body: Stack(children: [
        Container(
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: is_dark
                  ? [
                      const Color.fromARGB(255, 203, 122, 0),
                      const Color.fromARGB(255, 0, 112, 204),
                    ]
                  : [
                      Colors.orange,
                      Colors.blue,
                    ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              BackButton(
                style: const ButtonStyle(
                    padding:
                        MaterialStatePropertyAll(EdgeInsets.only(bottom: 10))),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  widget.is_income
                      ? LocaleData.in_category_manage_appbar.getString(context)
                      : LocaleData.ex_category_manage_appbar.getString(context),
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              IconButton(
                  padding: const EdgeInsets.all(15),
                  onPressed: () {
                    delete_all_category();
                  },
                  icon: const Icon(Icons.delete_sweep,
                      color: Colors.redAccent, size: 28))
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(top: 90.0),
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: data.isNotEmpty
                    ? is_loading
                        ? ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: 12,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 7.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  height: 50.0,
                                ),
                              );
                            },
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(8),
                            itemCount: data.length,
                            itemBuilder: (BuildContext context, int index) {
                              final cat_item = data[index];

                              return Slidable(
                                closeOnScroll: true,
                                endActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        backgroundColor: Colors.transparent,
                                        onPressed: (context) {
                                          edit_cat(cat_item);
                                        },
                                        foregroundColor: Colors.blue,
                                        icon: Icons.edit,
                                        label: LocaleData.slide_edit
                                            .getString(context),
                                      ),
                                      SlidableAction(
                                        backgroundColor: Colors.transparent,
                                        onPressed: (context) {
                                          delete_cat(index, uid);
                                        },
                                        foregroundColor: Colors.red,
                                        icon: Icons.delete,
                                        label: LocaleData.slide_delete
                                            .getString(context),
                                      ),
                                    ]),
                                child: InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return cat_update_dialog(
                                            cat_item: cat_item,
                                          );
                                        });
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.black,
                                                width: 0))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                cat_item['icon'],
                                                style: const TextStyle(
                                                    fontSize: 28),
                                              ),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              Text(
                                                cat_item['name'],
                                                style: const TextStyle(
                                                    fontSize: 18),
                                              ),
                                            ],
                                          ),
                                          const Icon(Icons.navigate_next)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            })
                    : Center(
                        child: Text(LocaleData.no_cat_yet.getString(context)),
                      ))),
      ]),
    );
  }

  void delete_all_category() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(
              widget.is_income
                  ? LocaleData.in_delete_all_title.getString(context)
                  : LocaleData.ex_delete_all_title.getString(context),
            ),
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
                  onPressed: () async {
                    await db_helper
                        .delete_all_category(uid, widget.is_income)
                        .then((value) => toast.showToast(
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
                        .then((value) => Navigator.of(context).pop())
                        .then((value) {
                      category_manage.getState()!.fetch_data();
                      input_content.getState()!.fetch_data();
                    });
                  },
                  child: Text(
                    LocaleData.confirm.getString(context),
                  )),
            ],
          );
        });
  }

  void edit_cat(Map<String, dynamic> cat_item) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return cat_update_dialog(
            cat_item: cat_item,
          );
        });
  }

  void delete_cat(int index, String uid) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection("category")
          .doc(data[index]['cat_id'])
          .delete();
      setState(() {
        data.removeAt(index);
      });

      input_content.getState()!.fetch_data();

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
    } catch (error) {
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

  Future<void> fetch_data() async {
    List<Map<String, dynamic>> temp =
        await db_helper.fetch_categories(uid, widget.is_income);

    if (is_mounted) {
      setState(() {
        data = temp;
        is_loading = false;
      });
    }
  }
}
