import 'dart:ffi';
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
import 'package:money_mate/widget/home/home_appbar.dart';
import 'package:money_mate/widget/input/update_input.dart';
import 'package:shimmer/shimmer.dart';

class home_list_item extends StatefulWidget {
  static final home_list_item_globalkey = GlobalKey<_home_list_itemState>();

  static _home_list_itemState? getState() {
    return home_list_item_globalkey.currentState;
  }

  home_list_item() : super(key: home_list_item_globalkey);

  @override
  State<home_list_item> createState() => _home_list_itemState();
}

class _home_list_itemState extends State<home_list_item> {
  firestore_helper db_helper = firestore_helper();
  List<Map<String, dynamic>> input_data = [];
  bool is_loading = true;
  bool is_mounted = false;
  FToast toast = FToast();
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final localization = FlutterLocalization.instance;

  @override
  void initState() {
    is_mounted = true;
    fetch_data_list();
    super.initState();
  }

  @override
  void dispose() {
    is_mounted = false;
    super.dispose();
  }

  Future<void> fetch_data_list() async {
    List<Map<String, dynamic>> temp =
        await db_helper.fetch_input(uid, home_appbar.getState()!.formattedDate);

    if (is_mounted) {
      setState(() {
        input_data = temp;
        is_loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool is_dark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final date_group = <String, List<Map<String, dynamic>>>{};
    for (final item in input_data) {
      final date = item['date'] as String;
      date_group.putIfAbsent(date, () => []);
      date_group[date]!.add(item);
    }

    toast.init(context);

    final sorted_list = date_group.keys.toList()
      ..sort((a, b) => DateFormat('dd/MM/yyyy')
          .parse(b)
          .compareTo(DateFormat('dd/MM/yyyy').parse(a)));

    return Expanded(
      child: is_loading
          ? ListView.builder(
              padding: const EdgeInsets.only(bottom: 100),
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return Shimmer.fromColors(
                  baseColor: is_dark ? Colors.grey[700]! : Colors.grey[300]!,
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
          : input_data.isEmpty
              ? Center(
                  child: Text(LocaleData.no_input_data.getString(context)),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 24, bottom: 120),
                  itemCount: sorted_list.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    final date = sorted_list[index];
                    final list_item = date_group[date]!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(
                              left: 10, top: 8, bottom: 8),
                          decoration: BoxDecoration(
                              color: is_dark
                                  ? Colors.grey[700]
                                  : Colors.grey[200]),
                          child: Text(
                            date,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Column(
                          children:
                              List.generate(list_item.length, (itemIndex) {
                            final input_item = list_item[itemIndex];
                            var formatter = NumberFormat.simpleCurrency(
                                locale: localization.currentLocale.toString());
                            String format_money =
                                formatter.format(input_item['money']);
                            return Slidable(
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    backgroundColor: Colors.transparent,
                                    onPressed: (context) {
                                      handle_edit(context, input_item);
                                    },
                                    foregroundColor: Colors.blue,
                                    icon: Icons.edit,
                                    label: 'Edit',
                                  ),
                                  SlidableAction(
                                    backgroundColor: Colors.transparent,
                                    onPressed: (context) {
                                      handle_delete(
                                          context, input_item['id'], uid);
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
                                          builder: (BuildContext context) =>
                                              update_input(
                                                  input_item: input_item)));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 14, bottom: 14, left: 24, right: 24),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                boxShadow: is_dark
                                                    ? null
                                                    : [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.3),
                                                          spreadRadius: 2,
                                                          blurRadius: 7,
                                                          offset: const Offset(
                                                              -5, 5),
                                                        )
                                                      ],
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                            child: CircleAvatar(
                                                backgroundColor: Colors
                                                    .primaries[Random().nextInt(
                                                        Colors
                                                            .primaries.length)]
                                                    .shade100
                                                    .withOpacity(0.35),
                                                radius: 28,
                                                child: Text(
                                                  input_item['icon'],
                                                  style: const TextStyle(
                                                      fontSize: 38),
                                                )),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: width * 0.4,
                                                  child: Text(
                                                    input_item['description'],
                                                    softWrap: true,
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),
                                                Text(
                                                  input_item['date'],
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.grey),
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
                                            '${input_item['is_income'] ? '+' : '-'} ${format_money}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: input_item['is_income']
                                                    ? Colors.green
                                                    : Colors.red),
                                          ),
                                          Text(
                                            input_item['name'],
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.grey),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    );
                  },
                ),
    );
  }

  void handle_edit(
      BuildContext context, Map<String, dynamic> input_item) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                update_input(input_item: input_item)));
  }

  void handle_delete(BuildContext context, String input_id, String uid) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection("input")
          .doc(input_id)
          .delete();

      fetch_data_list();

      if (home_appbar.getState() != null) {
        home_appbar.getState()!.fetchData();
      }

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
}
