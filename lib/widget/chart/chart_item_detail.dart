import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:money_mate/widget/input/update_input.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class chart_item_detail extends StatefulWidget {
  final data;
  bool? is_monthly;
  chart_item_detail({super.key, this.data, this.is_monthly});

  @override
  State<chart_item_detail> createState() => _chart_item_detailState();
}

class _chart_item_detailState extends State<chart_item_detail> {
  List<Map<String, dynamic>> data = [];
  FToast toast = FToast();
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void fetchData() {
    data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    final date_group = <String, List<Map<String, dynamic>>>{};
    List<String> sorted_list = [];

    if (widget.is_monthly!) {
      for (final item in data) {
        final date = item['date'] as String;
        date_group.putIfAbsent(date, () => []);
        date_group[date]!.add(item);
      }
      sorted_list = date_group.keys.toList()
        ..sort((a, b) => DateFormat('dd/MM/yyyy')
            .parse(b)
            .compareTo(DateFormat('dd/MM/yyyy').parse(a)));
    } else {
      for (final item in data) {
        final date = item['date'] as String;
        final monthYear =
            date.substring(3); // Extract month/year part from the date
        date_group.putIfAbsent(monthYear, () => []);
        date_group[monthYear]!.add(item);
      }

      sorted_list = date_group.keys.toList()
        ..sort((a, b) => DateFormat('MM/yyyy')
            .parse(b)
            .compareTo(DateFormat('MM/yyyy').parse(a)));
    }

    toast.init(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('${data.first['name']} details'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 300,
            child: SfCartesianChart(
              primaryXAxis: const CategoryAxis(),
              series: <CartesianSeries<Map<String, dynamic>, String>>[
                ColumnSeries<Map<String, dynamic>, String>(
                  dataSource: sorted_list.reversed.expand((date) {
                    final totalMoney = date_group[date]!
                        .map<double>((item) => item['money'] as double)
                        .fold<double>(0, (prev, amount) => prev + amount);
                    return [
                      {'date': date, 'money': totalMoney}
                    ];
                  }).toList(),
                  xValueMapper: (datum, _) => datum['date'].toString(),
                  yValueMapper: (datum, _) => datum['money'],
                  animationDuration: 1000,
                  dataLabelMapper: (datum, _) {
                    return NumberFormat.simpleCurrency(locale: "vi_VN")
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
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
            padding: const EdgeInsets.only(top: 24),
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
                    padding: const EdgeInsets.only(left: 10, top: 8, bottom: 8),
                    decoration: BoxDecoration(color: Colors.grey[200]),
                    child: Text(
                      date,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Column(
                    children: List.generate(list_item.length, (itemIndex) {
                      final input_item = list_item[itemIndex];

                      var formatter =
                          NumberFormat.simpleCurrency(locale: "vi_VN");
                      String format_money =
                          formatter.format(input_item['money']);
                      return Slidable(
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                handle_edit(context, input_item);
                              },
                              foregroundColor: Colors.blue,
                              icon: Icons.edit,
                              label: 'Edit',
                            ),
                            SlidableAction(
                              onPressed: (context) {
                                handle_delete(context, input_item['id'], uid);
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
                                        update_input(input_item: input_item)));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 14, bottom: 14, left: 24, right: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.3),
                                              spreadRadius: 2,
                                              blurRadius: 7,
                                              offset: const Offset(-5, 5),
                                            )
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: CircleAvatar(
                                          backgroundColor: Colors
                                              .primaries[Random().nextInt(
                                                  Colors.primaries.length)]
                                              .shade100
                                              .withOpacity(0.35),
                                          radius: 28,
                                          child: Text(
                                            input_item['icon'],
                                            style:
                                                const TextStyle(fontSize: 38),
                                          )),
                                    ),
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
                                              input_item['description'],
                                              softWrap: true,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          Text(
                                            input_item['date'],
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
        ],
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

      fetchData();

      toast.showToast(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.green,
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.check),
              Text("Delete success!"),
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
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.do_disturb),
              Text("Fail delete!"),
            ],
          ),
        ),
        gravity: ToastGravity.CENTER,
        toastDuration: const Duration(seconds: 2),
      );
    }
  }
}
