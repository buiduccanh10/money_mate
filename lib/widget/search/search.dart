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
import 'package:money_mate/view_model/search_view_model.dart';
import 'package:money_mate/widget/input/update_input.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class search extends StatefulWidget {
  const search({super.key});

  @override
  State<search> createState() => _searchState();
}

class _searchState extends State<search> {
  @override
  void initState() {
    var search_vm = Provider.of<search_view_model>(context, listen: false);
    search_vm.results.clear();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool is_dark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<search_view_model>(
      builder: (BuildContext context, search_vm, Widget? child) {
        search_vm.toast.init(context);
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
                            search_vm.timer?.cancel();
                            search_vm.timer =
                                Timer(const Duration(milliseconds: 500), () {
                              if (query.isEmpty) {
                                setState(() {
                                  search_vm.results = [];
                                });
                              } else {
                                search_vm.search(search_vm.uid, query, context);
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
                            children: List.generate((search_vm.cat_list.length),
                                (index) {
                              return search_vm.is_loading
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
                                        search_vm.search_by_cat(
                                            search_vm.uid,
                                            search_vm.cat_list[index]['cat_id'],
                                            context);
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
                                              search_vm.cat_list[index]['icon'],
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(search_vm.cat_list[index]
                                                ['name'])
                                          ],
                                        ),
                                      ),
                                    );
                            }),
                          ),
                        ),
                        search_vm.results.isEmpty
                            ? Image.asset(
                                'assets/search.png',
                                width: 250,
                                filterQuality: FilterQuality.high,
                              )
                            : search_vm.is_loading
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
                                        itemCount: search_vm.results.length,
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          var formatter =
                                              NumberFormat.simpleCurrency(
                                                  locale: search_vm.localization
                                                      .currentLocale
                                                      .toString());
                                          String format_money = formatter
                                              .format(search_vm.results[index]
                                                  ['money']);
                                          return Slidable(
                                            endActionPane: ActionPane(
                                              motion: const ScrollMotion(),
                                              children: [
                                                SlidableAction(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  onPressed: (context) {
                                                    search_vm.handle_edit(
                                                        search_vm
                                                            .results[index],
                                                        context);
                                                  },
                                                  foregroundColor: Colors.blue,
                                                  icon: Icons.edit,
                                                  label: LocaleData.slide_edit
                                                      .getString(context),
                                                ),
                                                SlidableAction(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  onPressed: (context) {
                                                    search_vm.handle_delete(
                                                        search_vm.results[index]
                                                            ['id'],
                                                        search_vm.uid,
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
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            update_input(
                                                                input_item: search_vm
                                                                        .results[
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
                                                          decoration:
                                                              BoxDecoration(
                                                                  boxShadow:
                                                                      is_dark
                                                                          ? null
                                                                          : [
                                                                              BoxShadow(
                                                                                color: Colors.grey.withOpacity(0.3),
                                                                                spreadRadius: 2,
                                                                                blurRadius: 7,
                                                                                offset: const Offset(-5, 5),
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
                                                                search_vm.results[
                                                                        index]
                                                                    ['icon'],
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            38),
                                                              )),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 12.0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                // width: width * 0.4,
                                                                child: Text(
                                                                  search_vm.results[
                                                                          index]
                                                                      [
                                                                      'description'],
                                                                  softWrap:
                                                                      true,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700),
                                                                ),
                                                              ),
                                                              Text(
                                                                search_vm.results[
                                                                        index]
                                                                    ['date'],
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        14,
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
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Text(
                                                          '${search_vm.results[index]['is_income'] ? '+' : '-'} ${format_money}',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: search_vm.results[
                                                                          index]
                                                                      [
                                                                      'is_income']
                                                                  ? Colors.green
                                                                  : Colors.red),
                                                        ),
                                                        Text(
                                                          search_vm.results[
                                                              index]['name'],
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: Colors
                                                                      .grey),
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
      },
    );
  }
}
