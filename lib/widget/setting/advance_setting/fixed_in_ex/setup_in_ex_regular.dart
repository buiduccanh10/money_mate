import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
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
import 'package:money_mate/view_model/setting_view_model.dart';
import 'package:money_mate/widget/setting/advance_setting/fixed_in_ex/start_setup.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class setup_in_ex_regular extends StatefulWidget {
  const setup_in_ex_regular({super.key});

  @override
  State<setup_in_ex_regular> createState() => _setup_in_ex_regularState();
}

class _setup_in_ex_regularState extends State<setup_in_ex_regular> {
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
    bool is_dark = Theme.of(context).brightness == Brightness.dark;
    return Consumer<setting_view_model>(
      builder: (BuildContext context, setting_vm, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(LocaleData.fixed_in_ex.getString(context)),
            actions: [
              IconButton(
                  onPressed: () {
                    setting_vm.delete_all_schedule(context);
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
              setting_vm.data.isEmpty
                  ? Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.35),
                      child: Center(
                          child: Text(
                        LocaleData.no_set_up_yet.getString(context),
                        style: const TextStyle(fontSize: 18),
                      )),
                    )
                  : setting_vm.is_loading
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
                            itemCount: setting_vm.data.length,
                            itemBuilder: (BuildContext context, index) {
                              var formatter = NumberFormat.simpleCurrency(
                                  locale: setting_vm
                                      .localization.currentLocale
                                      .toString());
                              String format_money = formatter
                                  .format(setting_vm.data[index]['money']);
                              return Slidable(
                                endActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      backgroundColor: Colors.transparent,
                                      onPressed: (context) {
                                        setting_vm.handle_delete(
                                            int.parse(
                                                setting_vm.data[index]['id']),
                                            index,
                                            context);
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
                                                  setting_vm.data[index]
                                                      ['icon'],
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
                                                  // width: width * 0.4,
                                                  child: Text(
                                                    '${setting_vm.data[index]['description']} (${setting_vm.data[index]['option']})',
                                                    softWrap: true,
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),
                                                Text(
                                                  setting_vm.data[index]
                                                      ['date'],
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
                                            '${setting_vm.data[index]['is_income'] ? '+' : '-'} ${format_money}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: setting_vm.data[index]
                                                        ['is_income']
                                                    ? Colors.green
                                                    : Colors.red),
                                          ),
                                          Text(
                                            setting_vm.data[index]['name'],
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => const start_setup()));
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
      },
    );
  }
}
