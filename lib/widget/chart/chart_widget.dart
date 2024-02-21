import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String month_year_formated = '';
  bool? is_income;
  bool is_loading = true;
  bool is_mounted = false;
  double total_income = 0;
  double total_expense = 0;
  double total_saving = 0;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  var month = DateTime.now().month;
  var year = DateTime.now().year;

  @override
  void initState() {
    is_income = true;
    is_mounted = true;
    month_year_formated = getMonthYearString(month, year);
    tooltipBehavior = TooltipBehavior(enable: true);
    is_month();
    super.initState();
  }

  @override
  void didUpdateWidget(chart_widget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.is_monthly != widget.is_monthly) {
      is_month();
    }
  }

  @override
  void dispose() {
    is_mounted = false;
    super.dispose();
  }

  String getMonthYearString(int month, int year) {
    final DateTime dateTime = DateTime(year, month);
    final DateFormat formatter = DateFormat('MMMM yyyy');
    return formatter.format(dateTime);
  }

  void is_month() {
    if (widget.is_monthly) {
      fecth_data_bymonth();
    } else {
      fecth_data_byyear();
    }
  }

  Future<void> fecth_data_bymonth() async {
    List<Map<String, dynamic>> income_temp = await db_helper
        .fetch_data_cat_bymonth(uid, month_year_formated, isIncome: true);
    List<Map<String, dynamic>> expense_temp = await db_helper
        .fetch_data_cat_bymonth(uid, month_year_formated, isIncome: false);

    if (is_mounted) {
      setState(() {
        income_categories = income_temp;
        expense_categories = expense_temp;
        calculateTotals();
        is_loading = false;
      });
    }
  }

  Future<void> fecth_data_byyear() async {
    List<Map<String, dynamic>> income_temp = await db_helper
        .fetch_data_cat_byyear(uid, year.toString(), isIncome: true);
    List<Map<String, dynamic>> expense_temp = await db_helper
        .fetch_data_cat_byyear(uid, year.toString(), isIncome: false);

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
    var formatter = NumberFormat.simpleCurrency(locale: "vi_VN");
    String format_total = formatter.format(total_saving);
    String format_income = formatter.format(total_income);
    String format_expense = formatter.format(total_expense);

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: height * 0.09),
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
                            child: widget.is_monthly
                                ? SizedBox(
                                    height: 50,
                                    child: DropdownDatePicker(
                                        width: 5,
                                        selectedMonth: month,
                                        selectedYear: year,
                                        inputDecoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        icon: const Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.grey,
                                          size: 30,
                                        ),
                                        onChangedMonth: (newMonth) {
                                          setState(() {
                                            month = int.parse(newMonth!);
                                            month_year_formated =
                                                getMonthYearString(month, year);
                                            fecth_data_bymonth();
                                          });
                                        },
                                        onChangedYear: (newYear) {
                                          setState(() {
                                            year = int.parse(newYear!);
                                            month_year_formated =
                                                getMonthYearString(month, year);
                                            fecth_data_bymonth();
                                          });
                                        },
                                        showDay: false,
                                        yearFlex: 2,
                                        monthFlex: 3))
                                : SizedBox(
                                    height: 50,
                                    child: DropdownDatePicker(
                                      width: width * 0.15,
                                      selectedYear: year,
                                      boxDecoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      inputDecoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                      icon: const Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.grey,
                                        size: 30,
                                      ),
                                      onChangedYear: (newYear) {
                                        setState(() {
                                          year = int.parse(newYear!);
                                          fecth_data_byyear();
                                        });
                                      },
                                      showDay: false,
                                      showMonth: false,
                                    )),
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
                                          '+$format_income',
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
                                        '-$format_expense',
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
                                    '$format_total',
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

                                String money_format =
                                    formatter.format(cat_item['money']);

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
                                              Text(
                                                '${is_income! ? '+' : '-'} ${money_format}',
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w400),
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
}
