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
import 'package:money_mate/view_model/category_view_model.dart';
import 'package:money_mate/widget/category/cat_add_dialog.dart';
import 'package:money_mate/widget/category/cat_update_dialog.dart';
import 'package:money_mate/widget/input/input_content.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class category_manage extends StatefulWidget {
  bool is_income;
  category_manage({super.key,required this.is_income});

  @override
  State<category_manage> createState() => _category_manageState();
}

class _category_manageState extends State<category_manage> {
  @override
  void initState() {
    var cat_vm = Provider.of<category_view_model>(context, listen: false);
    cat_vm.fetch_data(widget.is_income);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool is_dark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<category_view_model>(
      builder: (BuildContext context, cat_vm, Widget? child) {
        cat_vm.toast.init(context);
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
                        padding: MaterialStatePropertyAll(
                            EdgeInsets.only(bottom: 10))),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      widget.is_income
                          ? LocaleData.in_category_manage_appbar
                              .getString(context)
                          : LocaleData.ex_category_manage_appbar
                              .getString(context),
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  IconButton(
                      padding: const EdgeInsets.all(15),
                      onPressed: () {
                        cat_vm.delete_all_category(context, widget.is_income);
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
                    child: cat_vm.data.isNotEmpty
                        ? cat_vm.is_loading
                            ? ListView.builder(
                                padding: const EdgeInsets.all(8),
                                itemCount: 12,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 7.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      height: 50.0,
                                    ),
                                  );
                                },
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(8),
                                itemCount: cat_vm.data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final cat_item = cat_vm.data[index];

                                  return Slidable(
                                    closeOnScroll: true,
                                    endActionPane: ActionPane(
                                        motion: const ScrollMotion(),
                                        children: [
                                          SlidableAction(
                                            backgroundColor: Colors.transparent,
                                            onPressed: (context) {
                                              cat_vm.edit_cat(
                                                  cat_item, context);
                                            },
                                            foregroundColor: Colors.blue,
                                            icon: Icons.edit,
                                            label: LocaleData.slide_edit
                                                .getString(context),
                                          ),
                                          SlidableAction(
                                            backgroundColor: Colors.transparent,
                                            onPressed: (context) {
                                              cat_vm.delete_cat(
                                                  index, cat_vm.uid, context);
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
                            child:
                                Text(LocaleData.no_cat_yet.getString(context)),
                          ))),
          ]),
        );
      },
    );
  }
}
