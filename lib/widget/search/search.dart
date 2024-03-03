import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:money_mate/services/firestore_helper.dart';
import 'package:money_mate/services/locales.dart';
import 'package:money_mate/widget/input/update_input.dart';
import 'package:shimmer/shimmer.dart';

class search extends StatefulWidget {
  static final search_globalkey = GlobalKey<_searchState>();

  static _searchState? getState() {
    return search_globalkey.currentState;
  }

  search() : super(key: search.search_globalkey);

  @override
  State<search> createState() => _searchState();
}

class _searchState extends State<search> {
  final db_helper = firestore_helper();
  final uid = FirebaseAuth.instance.currentUser!.uid;
  List<Map<String, dynamic>> results = [];
  List<Map<String, dynamic>> cat_list = [];
  bool is_mounted = false;
  bool is_loading = true;
  FToast toast = FToast();
  Timer? timer;

  @override
  void initState() {
    fetch_categories();
    is_mounted = true;
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    is_mounted = false;
    super.dispose();
  }

  Future<void> fetch_categories() async {
    List<Map<String, dynamic>> temp = await db_helper.fetch_all_categories(uid);
    if (mounted) {
      setState(() {
        cat_list = temp;
        is_loading = false;
      });
    }
  }

  void updated_item(Map<String, dynamic> updated_item) {
    setState(() {
      int index =
          results.indexWhere((item) => item['id'] == updated_item['id']);
      if (index != -1) {
        results[index] = updated_item;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    toast.init(context);
    bool is_dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, bottom: 8, left: 14, right: 14),
                child: Column(
                  children: [
                    SearchBar(
                      padding: const MaterialStatePropertyAll<EdgeInsets>(
                          EdgeInsets.symmetric(horizontal: 16.0)),
                      onChanged: (query) {
                        timer?.cancel();
                        timer = Timer(const Duration(milliseconds: 500), () {
                          if (query.isEmpty) {
                            setState(() {
                              results = [];
                            });
                          } else {
                            search(uid, query);
                          }
                        });
                      },
                      hintText:
                          LocaleData.type_any_to_search.getString(context),
                      leading: const Icon(
                        Icons.search,
                        size: 28,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 26.0),
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: List.generate((cat_list.length), (index) {
                          return is_loading
                              ? Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    width: 70,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors
                                            .primaries[Random().nextInt(
                                                Colors.primaries.length)]
                                            .shade100
                                            .withOpacity(0.35),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    padding: const EdgeInsets.all(8),
                                  ),
                                )
                              : InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () {
                                    search_by_cat(
                                        uid, cat_list[index]['cat_id']);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors
                                            .primaries[Random().nextInt(
                                                Colors.primaries.length)]
                                            .shade100
                                            .withOpacity(0.35),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          cat_list[index]['icon'],
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(cat_list[index]['name'])
                                      ],
                                    ),
                                  ),
                                );
                        }),
                      ),
                    ),
                    results.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(26.0),
                            child: Image.asset(
                              'assets/Search.png',
                              width: MediaQuery.of(context).size.width * 0.4,
                            ),
                          )
                        : is_loading
                            ? Expanded(
                                child: ListView.builder(
                                  itemCount: 5,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10,
                                            bottom: 10,
                                            left: 24,
                                            right: 24),
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
                                ),
                              )
                            : Expanded(
                                child: ListView.builder(
                                    padding: const EdgeInsets.only(
                                        top: 20, bottom: 0),
                                    itemCount: results.length,
                                    shrinkWrap: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var formatter =
                                          NumberFormat.simpleCurrency(
                                              locale: "vi_VN");
                                      String format_money = formatter
                                          .format(results[index]['money']);
                                      return Slidable(
                                        endActionPane: ActionPane(
                                          motion: const ScrollMotion(),
                                          children: [
                                            SlidableAction(
                                              backgroundColor:
                                                  Colors.transparent,
                                              onPressed: (context) {
                                                handle_edit(
                                                    context, results[index]);
                                              },
                                              foregroundColor: Colors.blue,
                                              icon: Icons.edit,
                                              label: 'Edit',
                                            ),
                                            SlidableAction(
                                              backgroundColor:
                                                  Colors.transparent,
                                              onPressed: (context) {
                                                handle_delete(
                                                    context,
                                                    results[index]['id'],
                                                    uid,
                                                    index);
                                              },
                                              foregroundColor: Colors.red,
                                              icon: Icons.delete,
                                              label: 'Delete',
                                            ),
                                          ],
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        update_input(
                                                            input_item: results[
                                                                index])));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 14,
                                                bottom: 14,
                                                left: 24,
                                                right: 24),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          boxShadow: is_dark
                                                              ? null
                                                              : [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.3),
                                                                    spreadRadius:
                                                                        2,
                                                                    blurRadius:
                                                                        7,
                                                                    offset:
                                                                        const Offset(
                                                                            -5,
                                                                            5),
                                                                  )
                                                                ],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50)),
                                                      child: CircleAvatar(
                                                          backgroundColor: Colors
                                                              .primaries[Random()
                                                                  .nextInt(Colors
                                                                      .primaries
                                                                      .length)]
                                                              .shade100
                                                              .withOpacity(
                                                                  0.35),
                                                          radius: 28,
                                                          child: Text(
                                                            results[index]
                                                                ['icon'],
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        38),
                                                          )),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 12.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            // width: width * 0.4,
                                                            child: Text(
                                                              results[index][
                                                                  'description'],
                                                              softWrap: true,
                                                              style: const TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            ),
                                                          ),
                                                          Text(
                                                            results[index]
                                                                ['date'],
                                                            style: const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Colors
                                                                    .grey),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      '${results[index]['is_income'] ? '+' : '-'} ${format_money}',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: results[index]
                                                                  ['is_income']
                                                              ? Colors.green
                                                              : Colors.red),
                                                    ),
                                                    Text(
                                                      results[index]['name'],
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.grey),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              )
                  ],
                ))));
  }

  Future<void> search(String uid, String query) async {
    List<Map<String, dynamic>> temp = await db_helper.search(uid, query);
    if (temp.isEmpty) {
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
              const Icon(Icons.search_off_outlined),
              Text(LocaleData.toast_not_found.getString(context)),
            ],
          ),
        ),
        gravity: ToastGravity.CENTER,
        toastDuration: const Duration(seconds: 3),
      );
    }
    setState(() {
      if (is_mounted = true) {
        results = temp;
        is_loading = false;
      }
    });
  }

  Future<void> search_by_cat(String uid, String cat_id) async {
    List<Map<String, dynamic>> temp =
        await db_helper.search_by_cat(uid, cat_id);

    if (temp.isEmpty) {
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
              const Icon(Icons.search_off_outlined),
              Text(LocaleData.toast_not_found.getString(context)),
            ],
          ),
        ),
        gravity: ToastGravity.CENTER,
        toastDuration: const Duration(seconds: 3),
      );
    }
    setState(() {
      if (is_mounted = true) {
        results = temp;
        is_loading = false;
      }
    });
  }

  void handle_edit(
      BuildContext context, Map<String, dynamic> input_item) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                update_input(input_item: input_item)));
  }

  void handle_delete(
      BuildContext context, String input_id, String uid, int index) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection("input")
          .doc(input_id)
          .delete();

      setState(() {
        results.removeAt(index);
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
              const Icon(Icons.delete),
              Text(LocaleData.toast_delete_success.getString(context)),
            ],
          ),
        ),
        gravity: ToastGravity.CENTER,
        toastDuration: const Duration(seconds: 3),
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
        toastDuration: const Duration(seconds: 3),
      );
    }
  }
}
