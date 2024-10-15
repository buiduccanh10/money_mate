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
import 'package:money_mate/widget/setting/advance_setting/limit_in_ex/cat_limit_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class setup_in_ex_limit extends StatefulWidget {
  const setup_in_ex_limit({super.key});

  @override
  State<setup_in_ex_limit> createState() => _setup_in_ex_limitState();
}

class _setup_in_ex_limitState extends State<setup_in_ex_limit> {
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
            title: Text(LocaleData.setting_limit_title.getString(context)),
            actions: [
              IconButton(
                  onPressed: () {
                    setting_vm.restore_all_limit(context);
                  },
                  icon: const Icon(
                    Icons.restore_page,
                    color: Colors.red,
                  ))
            ],
          ),
          body: SingleChildScrollView(
              child: Column(
            children: [
              setting_vm.ex_cat_data.isEmpty
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
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: 0),
                            itemCount: setting_vm.ex_cat_data.length,
                            itemBuilder: (BuildContext context, index) {
                              var formatter = NumberFormat.simpleCurrency(
                                  locale: setting_vm.localization.currentLocale
                                      .toString());
                              String format_money = formatter.format(
                                  setting_vm.ex_cat_data[index]['limit']);

                              return Slidable(
                                endActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      backgroundColor: Colors.transparent,
                                      onPressed: (context) {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return cat_limit_dialog(
                                                cat_id: setting_vm
                                                        .ex_cat_data[index]
                                                    ['cat_id'],
                                                cat_name: setting_vm
                                                    .ex_cat_data[index]['name'],
                                                limit: setting_vm
                                                        .ex_cat_data[index]
                                                    ['limit'],
                                              );
                                            });
                                      },
                                      foregroundColor: Colors.blue,
                                      icon: Icons.edit,
                                      label: LocaleData.slide_edit
                                          .getString(context),
                                    ),
                                    SlidableAction(
                                      backgroundColor: Colors.transparent,
                                      onPressed: (context) {
                                        setting_vm.handle_restore_cat_limit(
                                            setting_vm.ex_cat_data[index]
                                                ['cat_id'],
                                            context);
                                      },
                                      foregroundColor: Colors.red,
                                      icon: Icons.restore,
                                      label: LocaleData.restore_limit
                                          .getString(context),
                                    ),
                                  ],
                                ),
                                child: InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return cat_limit_dialog(
                                            cat_id: setting_vm
                                                .ex_cat_data[index]['cat_id'],
                                            cat_name: setting_vm
                                                .ex_cat_data[index]['name'],
                                            limit: setting_vm.ex_cat_data[index]
                                                ['limit'],
                                          );
                                        });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 14,
                                        bottom: 14,
                                        left: 24,
                                        right: 24),
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
                                                                .withOpacity(
                                                                    0.3),
                                                            spreadRadius: 2,
                                                            blurRadius: 7,
                                                            offset:
                                                                const Offset(
                                                                    -5, 5),
                                                          )
                                                        ],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              child: CircleAvatar(
                                                  backgroundColor: Colors
                                                      .primaries[Random()
                                                          .nextInt(Colors
                                                              .primaries
                                                              .length)]
                                                      .shade100
                                                      .withOpacity(0.35),
                                                  radius: 28,
                                                  child: Text(
                                                    setting_vm
                                                            .ex_cat_data[index]
                                                        ['icon'],
                                                    style: const TextStyle(
                                                        fontSize: 38),
                                                  )),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 12.0),
                                              child: Text(
                                                setting_vm.ex_cat_data[index]
                                                    ['name'],
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          setting_vm.ex_cat_data[index]
                                                      ['limit'] !=
                                                  0
                                              ? format_money
                                              : LocaleData.no_limit
                                                  .getString(context),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.grey),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
            ],
          )),
        );
      },
    );
  }
}
