import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class chart_widget extends StatefulWidget {
  bool is_monthly;
  chart_widget({super.key, required this.is_monthly});

  @override
  State<chart_widget> createState() => _chart_widgetState();
}

class _chart_widgetState extends State<chart_widget> {
  List<Map<String, dynamic>> outcome_categories = [];
  List<Map<String, dynamic>> income_categories = [];
  late TooltipBehavior tooltipBehavior;
  DateTime now = DateTime.now();
  String? month_format_date;
  String? year_format_date;
  bool? is_income;
  int total_income = 0;
  int total_outcome = 0;
  int total_in_out = 0;

  @override
  void initState() {
    // total_income =
    //     income_categories.fold(0, (int previousValue, income_cat cat) {
    //   return previousValue + (cat.total ?? 0);
    // });
    // total_outcome =
    //     outcome_categories.fold(0, (int previousValue, outcome_cat cat) {
    //   return previousValue + (cat.total ?? 0);
    // });

    total_in_out = total_income - total_outcome;

    is_income = true;
    month_format_date = DateFormat('MMMM yyyy').format(now);
    year_format_date = DateFormat('yyyy').format(now);
    tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 75.0),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 400,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.amber),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(5),
                              onTap: () => showCupertinoModalPopup(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return show_month_year_dialog(
                                        widget.is_monthly);
                                  }),
                              child: Text(
                                widget.is_monthly
                                    ? '$month_format_date'
                                    : '$year_format_date',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 197.5,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.amber),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Income: ',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      '+$total_income đ',
                                      style: const TextStyle(
                                          color: Colors.green,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Container(
                                width: 197.5,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.amber),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Expense: ',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      '-$total_outcome đ',
                                      style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: 400,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.amber),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total saving: ',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  '$total_in_out đ',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 160),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.grey))),
                            child: CustomSlidingSegmentedControl<int>(
                              initialValue: 1,
                              fixedWidth: 205,
                              innerPadding: const EdgeInsets.all(0),
                              children: {
                                1: Text(
                                  'Income',
                                  style: TextStyle(
                                      color: is_income!
                                          ? Colors.black
                                          : Colors.grey,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                                2: Text(
                                  'Expense',
                                  style: TextStyle(
                                      color: is_income == 2
                                          ? Colors.black
                                          : Colors.grey,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                              },
                              decoration: const BoxDecoration(
                                color: CupertinoColors.white,
                              ),
                              thumbDecoration: const BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1.5, color: Colors.black)),
                              ),
                              curve: Curves.linear,
                              onValueChanged: (value) {
                                if (value == 1) {
                                  setState(() {
                                    is_income = true;
                                  });
                                }
                                if (value == 2) {
                                  setState(() {
                                    is_income = false;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 190.0),
                    //   child: SizedBox(
                    //     height: 280,
                    //     child: SfCircularChart(
                    //       tooltipBehavior: tooltipBehavior,
                    //       series: <CircularSeries>[
                    //         is_income!
                    //             ? DoughnutSeries<income_cat, String>(
                    //                 dataSource: income_categories,
                    //                 xValueMapper: (income_cat data, _) =>
                    //                     data.name,
                    //                 yValueMapper: (income_cat data, _) =>
                    //                     data.total,
                    //                 dataLabelMapper: (income_cat data, _) =>
                    //                     data.name,
                    //                 dataLabelSettings: const DataLabelSettings(
                    //                     isVisible: true),
                    //                 enableTooltip: true,
                    //                 animationDuration: 1200,
                    //                 explode: true,
                    //               )
                    //             : DoughnutSeries<outcome_cat, String>(
                    //                 dataSource: outcome_categories,
                    //                 xValueMapper: (outcome_cat data, _) =>
                    //                     data.name,
                    //                 yValueMapper: (outcome_cat data, _) =>
                    //                     data.total,
                    //                 dataLabelMapper: (outcome_cat data, _) =>
                    //                     data.name,
                    //                 dataLabelSettings: const DataLabelSettings(
                    //                     isVisible: true),
                    //                 enableTooltip: true,
                    //                 animationDuration: 1200,
                    //                 explode: true,
                    //               ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(top: 430),
                      child: SizedBox(
                        height: 400,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: is_income!
                              ? income_categories.length
                              : outcome_categories.length,
                          itemBuilder: (BuildContext context, int index) {
                            final cat_item = is_income!
                                ? income_categories[index]
                                : outcome_categories[index];

                            return InkWell(
                              onTap: () {},
                              child: Container(
                                decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.black, width: 0)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 15, top: 8, bottom: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            (cat_item as dynamic).icon!,
                                            style:
                                                const TextStyle(fontSize: 28),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            (cat_item as dynamic).name!,
                                            style:
                                                const TextStyle(fontSize: 18),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 25.0),
                                            child: Text(
                                              '${is_income! ? '+' : '-'} ${(cat_item as dynamic).total} đ',
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                          const Icon(Icons.navigate_next)
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget show_month_year_dialog(bool is_monthly) {
    return Container(
      height: 250,
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () {
                    setState(() {
                      if (is_monthly) {
                        month_format_date = DateFormat('MMMM yyyy').format(now);
                      }
                    });
                    Navigator.pop(context);
                  },
                  child:
                      const Text('OK', style: TextStyle(color: Colors.green)))
            ],
          ),
          SizedBox(
            height: 200,
            child: is_monthly
                ? CupertinoDatePicker(
                    initialDateTime: now,
                    mode: CupertinoDatePickerMode.monthYear,
                    onDateTimeChanged: (DateTime datetime) {
                      now = datetime;
                    })
                : BottomSheet(
                    onClosing: () {},
                    builder: (BuildContext context) {
                      return Material(
                        color: Colors.white,
                        child: YearPicker(
                          firstDate: DateTime(1),
                          lastDate: DateTime(9999),
                          selectedDate: now,
                          onChanged: (DateTime datetime) {
                            setState(() {
                              now = datetime;
                              year_format_date = DateFormat('yyyy').format(now);
                            });
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
