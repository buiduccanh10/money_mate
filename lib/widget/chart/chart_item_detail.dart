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
import 'package:money_mate/view_model/chart_view_model.dart';
import 'package:money_mate/widget/chart/chart_widget.dart';
import 'package:money_mate/widget/home/home_appbar.dart';
import 'package:money_mate/widget/input/update_input.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class chart_item_detail extends StatefulWidget {
  String? cat_id;
  String? date;
  bool? is_income;
  bool? is_monthly;
  double? over;

  chart_item_detail(
      {super.key,
      this.cat_id,
      this.over,
      this.date,
      this.is_income,
      required this.is_monthly});

  @override
  State<chart_item_detail> createState() => _chart_item_detailState();
}

class _chart_item_detailState extends State<chart_item_detail> {
  @override
  void initState() {
    var chart_vm = Provider.of<chart_view_model>(context, listen: false);
    chart_vm.fetch_data(chart_vm.uid, widget.is_monthly, widget.is_income,
        widget.date, widget.cat_id);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool is_dark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<chart_view_model>(
      builder: (BuildContext context, chart_vm, Widget? child) {
        final date_group = <String, List<Map<String, dynamic>>>{};
        List<String> sorted_list = [];

        if (widget.is_monthly!) {
          for (final item in chart_vm.data) {
            final date = item['date'] as String;
            date_group.putIfAbsent(date, () => []);
            date_group[date]!.add(item);
          }
          sorted_list = date_group.keys.toList()
            ..sort((a, b) => DateFormat('dd/MM/yyyy')
                .parse(b)
                .compareTo(DateFormat('dd/MM/yyyy').parse(a)));
        } else {
          for (final item in chart_vm.data) {
            final date = item['date'] as String;
            final monthYear = date.substring(3);
            date_group.putIfAbsent(monthYear, () => []);
            date_group[monthYear]!.add(item);
          }

          sorted_list = date_group.keys.toList()
            ..sort((a, b) => DateFormat('MM/yyyy')
                .parse(b)
                .compareTo(DateFormat('MM/yyyy').parse(a)));
        }

        chart_vm.toast.init(context);

        var formatter = NumberFormat.simpleCurrency(
            locale: chart_vm.localization.currentLocale.toString());

        String? formattedDate;
        try {
          if (widget.is_monthly!) {
            formattedDate = DateFormat('MM/yyyy').format(
                DateFormat('dd/MM/yyyy').parse(chart_vm.data.first['date']));
          } else {
            formattedDate = DateFormat('yyyy').format(
                DateFormat('dd/MM/yyyy').parse(chart_vm.data.first['date']));
          }
        } catch (err) {}
        return PopScope(
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) {
              widget.is_monthly!
                  ? chart_vm.fecth_data_bymonth() 
                  : chart_vm.fecth_data_byyear();
            }
          },
          child: Scaffold(
            body: Column(
              children: [
                Stack(children: [
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: is_dark
                            ? [
                                const Color.fromARGB(255, 0, 112, 204),
                                const Color.fromARGB(255, 203, 122, 0)
                              ]
                            : [Colors.orange, Colors.blue],
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        BackButton(onPressed: () {
                          Navigator.pop(context);
                        }),
                        Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: chart_vm.data.isNotEmpty
                                ? Text(
                                    '${chart_vm.data.first['name']} (${widget.is_monthly! ? formattedDate : formattedDate})${widget.over! > 0 ? ': ${LocaleData.over.getString(context)} ${formatter.format(widget.over)}' : ''}',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  )
                                : Text(LocaleData.no_input_data
                                    .getString(context))),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 120),
                    child: SingleChildScrollView(
                      child: chart_vm.data.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(top: 250),
                              child: Center(
                                child: Text(LocaleData.no_input_data
                                    .getString(context)),
                              ),
                            )
                          : Column(
                              children: [
                                SizedBox(
                                  height: 300,
                                  child: chart_vm.is_loading
                                      ? const SizedBox(
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()))
                                      : SfCartesianChart(
                                          primaryXAxis: const CategoryAxis(),
                                          series: <CartesianSeries<
                                              Map<String, dynamic>, String>>[
                                            ColumnSeries<Map<String, dynamic>,
                                                String>(
                                              dataSource: sorted_list.reversed
                                                  .expand((date) {
                                                final totalMoney = date_group[
                                                        date]!
                                                    .map<double>((item) =>
                                                        item['money'] as double)
                                                    .fold<double>(
                                                        0,
                                                        (prev, amount) =>
                                                            prev + amount);
                                                return [
                                                  {
                                                    'date': date,
                                                    'money': totalMoney
                                                  }
                                                ];
                                              }).toList(),
                                              xValueMapper: (datum, _) =>
                                                  datum['date'].toString(),
                                              yValueMapper: (datum, _) =>
                                                  datum['money'],
                                              animationDuration: 1000,
                                              dataLabelMapper: (datum, _) {
                                                return NumberFormat
                                                        .simpleCurrency(
                                                            locale: chart_vm
                                                                .localization
                                                                .currentLocale
                                                                .toString())
                                                    .format(datum['money']);
                                              },
                                              pointColorMapper: (datum, _) {
                                                final random = Random();
                                                return Color.fromRGBO(
                                                  random.nextInt(256),
                                                  random.nextInt(256),
                                                  random.nextInt(256),
                                                  1,
                                                );
                                              },
                                              dataLabelSettings:
                                                  const DataLabelSettings(
                                                isVisible: true,
                                                color: Colors.amber,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.52,
                                  child: chart_vm.is_loading
                                      ? ListView.builder(
                                          padding:
                                              const EdgeInsets.only(bottom: 0),
                                          itemCount: 5,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Shimmer.fromColors(
                                              baseColor: Colors.grey[300]!,
                                              highlightColor: Colors.grey[100]!,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8,
                                                    bottom: 8,
                                                    left: 10),
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
                                                    decoration:
                                                        const BoxDecoration(
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
                                      : ListView.builder(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          itemCount: sorted_list.length,
                                          shrinkWrap: true,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            final date = sorted_list[index];
                                            final list_item = date_group[date]!;
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10,
                                                          top: 8,
                                                          bottom: 8),
                                                  decoration: BoxDecoration(
                                                      color: is_dark
                                                          ? Colors.grey[700]
                                                          : Colors.grey[200]),
                                                  child: Text(
                                                    date,
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Column(
                                                  children: List.generate(
                                                      list_item.length,
                                                      (itemIndex) {
                                                    final input_item =
                                                        list_item[itemIndex];

                                                    var formatter = NumberFormat
                                                        .simpleCurrency(
                                                            locale: chart_vm
                                                                .localization
                                                                .currentLocale
                                                                .toString());
                                                    String format_money =
                                                        formatter.format(
                                                            input_item[
                                                                'money']);
                                                    return Slidable(
                                                      endActionPane: ActionPane(
                                                        motion:
                                                            const ScrollMotion(),
                                                        children: [
                                                          SlidableAction(
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            onPressed:
                                                                (context) {
                                                              chart_vm
                                                                  .handle_edit(
                                                                      input_item,
                                                                      context);
                                                            },
                                                            foregroundColor:
                                                                Colors.blue,
                                                            icon: Icons.edit,
                                                            label: LocaleData
                                                                .slide_edit
                                                                .getString(
                                                                    context),
                                                          ),
                                                          SlidableAction(
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            onPressed:
                                                                (context) {
                                                              chart_vm
                                                                  .handle_delete(
                                                                      input_item[
                                                                          'id'],
                                                                      chart_vm
                                                                          .uid,
                                                                      context);
                                                            },
                                                            foregroundColor:
                                                                Colors.red,
                                                            icon: Icons.delete,
                                                            label: LocaleData
                                                                .slide_delete
                                                                .getString(
                                                                    context),
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
                                                                          input_item:
                                                                              input_item)));
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
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
                                                                                  color: Colors.grey.withOpacity(0.3),
                                                                                  spreadRadius: 2,
                                                                                  blurRadius: 7,
                                                                                  offset: const Offset(-5, 5),
                                                                                )
                                                                              ],
                                                                        borderRadius: BorderRadius.circular(50)),
                                                                    child: CircleAvatar(
                                                                        backgroundColor: Colors.primaries[Random().nextInt(Colors.primaries.length)].shade100.withOpacity(0.35),
                                                                        radius: 28,
                                                                        child: Text(
                                                                          input_item[
                                                                              'icon'],
                                                                          style:
                                                                              const TextStyle(fontSize: 38),
                                                                        )),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            12.0),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        SizedBox(
                                                                          // width: width * 0.4,
                                                                          child:
                                                                              Text(
                                                                            input_item['description'],
                                                                            softWrap:
                                                                                true,
                                                                            style:
                                                                                const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          input_item[
                                                                              'date'],
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
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Text(
                                                                    '${input_item['is_income'] ? '+' : '-'} ${format_money}',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        color: input_item['is_income']
                                                                            ? Colors.green
                                                                            : Colors.red),
                                                                  ),
                                                                  Text(
                                                                    input_item[
                                                                        'name'],
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            16,
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
                                                  }).toList(),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                )
                              ],
                            ),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        );
      },
    );
  }
}
