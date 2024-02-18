import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_mate/services/firestore_helper.dart';
import 'package:shimmer/shimmer.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class chart_widget extends StatefulWidget {
  bool is_monthly;
  chart_widget({super.key, required this.is_monthly});

  @override
  State<chart_widget> createState() => _chart_widgetState();
}

class _chart_widgetState extends State<chart_widget> {
  firestore_helper db_helper = firestore_helper();
  List<Map<String, dynamic>> expense_categories = [];
  List<Map<String, dynamic>> income_categories = [];
  late TooltipBehavior tooltipBehavior;
  DateTime now = DateTime.now();
  String? month_format_date;
  String? year_format_date;
  bool? is_income;
  bool is_loading = true;
  bool is_mounted = false;
  double total_income = 0;
  double total_expense = 0;
  double total_saving = 0;

  @override
  void initState() {
    is_income = true;
    is_mounted = true;
    month_format_date = DateFormat('MMMM yyyy').format(now);
    year_format_date = DateFormat('yyyy').format(now);
    tooltipBehavior = TooltipBehavior(enable: true);
    fetchData();
    super.initState();
  }

  @override
  void dispose() {
    is_mounted = false;
    super.dispose();
  }

  Future<void> fetchData() async {
    List<Map<String, dynamic>> income_temp =
        await db_helper.fetch_data_by_cat(isIncome: true);
    List<Map<String, dynamic>> expense_temp =
        await db_helper.fetch_data_by_cat(isIncome: false);

    if (is_mounted) {
      setState(() {
        income_categories = income_temp;
        expense_categories = expense_temp;
        calculateTotals();
        is_loading = false;
      });
    }
  }

  void calculateTotals() {
    total_income = income_categories
        .map<double>((catItem) => (catItem['money']))
        .fold<double>(0, (prev, amount) => prev + amount);

    total_expense = expense_categories
        .map<double>((catItem) => (catItem['money']))
        .fold<double>(0, (prev, amount) => prev + amount);

    total_saving =
        double.parse((total_income - total_expense).toStringAsFixed(2));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    var formatter = NumberFormat("#,###", "vi_VN");
    String format_total = formatter.format(total_saving);
    String format_income = formatter.format(total_income);
    String format_expense = formatter.format(total_expense);

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: height * 0.08),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            width: width,
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
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: width * 0.02),
                                  child: Container(
                                    width: width * 0.47,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.amber),
                                        borderRadius:
                                            BorderRadius.circular(10)),
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
                                          '+$format_income đ',
                                          style: const TextStyle(
                                              color: Colors.green,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: width * 0.47,
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
                                        '-$format_expense đ',
                                        style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: width,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.amber),
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total saving: ',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    '$format_total đ',
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
                              fixedWidth: width * 0.5,
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
                                      color: is_income!
                                          ? Colors.grey
                                          : Colors.black,
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
                    Padding(
                      padding: const EdgeInsets.only(top: 190.0),
                      child: SizedBox(
                        height: 280,
                        child: is_loading
                            ? const Center(child: CircularProgressIndicator())
                            : SfCircularChart(
                                tooltipBehavior: tooltipBehavior,
                                series: <CircularSeries>[
                                  is_income!
                                      ? DoughnutSeries<Map<String, dynamic>,
                                          String>(
                                          dataSource: income_categories,
                                          xValueMapper: (datum, _) =>
                                              datum['name'],
                                          yValueMapper: (datum, _) =>
                                              (datum['money']),
                                          dataLabelMapper: (datum, _) =>
                                              datum['name'],
                                          dataLabelSettings:
                                              const DataLabelSettings(
                                                  isVisible: true),
                                          enableTooltip: true,
                                          animationDuration: 1200,
                                          explode: true,
                                        )
                                      : DoughnutSeries<Map<String, dynamic>,
                                          String>(
                                          dataSource: expense_categories,
                                          xValueMapper: (datum, _) =>
                                              datum['name'],
                                          yValueMapper: (datum, _) =>
                                              (datum['money']),
                                          dataLabelMapper: (datum, _) =>
                                              datum['name'],
                                          dataLabelSettings:
                                              const DataLabelSettings(
                                                  isVisible: true),
                                          enableTooltip: true,
                                          animationDuration: 1200,
                                          explode: true,
                                        ),
                                ],
                              ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 430),
                      child: is_loading
                          ? ListView.builder(
                              padding: const EdgeInsets.all(8),
                              shrinkWrap: true,
                              itemCount: 5,
                              itemBuilder: (BuildContext context, int index) {
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 7.0),
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
                              itemCount: is_income!
                                  ? income_categories.length
                                  : expense_categories.length,
                              itemBuilder: (BuildContext context, int index) {
                                final cat_item = is_income!
                                    ? income_categories[index]
                                    : expense_categories[index]
                                        as Map<String, dynamic>;

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
                                          left: 15.0,
                                          right: 15,
                                          top: 8,
                                          bottom: 8),
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
                                                width: 20,
                                              ),
                                              Text(
                                                cat_item['name'],
                                                style: const TextStyle(
                                                    fontSize: 18),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 20.0),
                                                child: Text(
                                                  '${is_income! ? '+' : '-'} ${cat_item['money']} đ',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400),
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
