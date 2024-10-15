import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:money_mate/services/firestore_helper.dart';
import 'package:money_mate/services/locales.dart';
import 'package:money_mate/view_model/chart_view_model.dart';
import 'package:money_mate/widget/chart/chart_item_detail.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:collection/collection.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class chart_widget extends StatefulWidget {
  bool is_monthly;

  chart_widget({super.key, required this.is_monthly});

  @override
  State<chart_widget> createState() => _chart_widgetState();
}

class _chart_widgetState extends State<chart_widget> {
  @override
  void initState() {
    var chart_vm = Provider.of<chart_view_model>(context, listen: false);
    chart_vm.is_month(widget.is_monthly);
    super.initState();
  }

  @override
  void didUpdateWidget(chart_widget oldWidget) {
    var chart_vm = Provider.of<chart_view_model>(context, listen: false);
    super.didUpdateWidget(oldWidget);
    if (oldWidget.is_monthly != widget.is_monthly) {
      chart_vm.is_month(widget.is_monthly);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool is_dark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;

    return Consumer<chart_view_model>(
      builder: (BuildContext context, chart_vm, Widget? child) {
        var formatter = NumberFormat.simpleCurrency(
            locale: chart_vm.localization.currentLocale.toString());
        String format_total = formatter.format(chart_vm.total_saving);
        String format_income = formatter.format(chart_vm.total_income);
        String format_expense = formatter.format(chart_vm.total_expense);

        return Scaffold(
          body: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 70),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Container(
                                width: width,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: is_dark
                                            ? Colors.orange
                                            : Colors.amber),
                                    borderRadius: BorderRadius.circular(10)),
                                child: SizedBox(
                                    height: 50,
                                    child: widget.is_monthly
                                        ? DropdownDatePicker(
                                            width: 0,
                                            selectedMonth: chart_vm.month,
                                            selectedYear: chart_vm.year,
                                            boxDecoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: is_dark
                                                    ? Colors.transparent
                                                    : Colors.white),
                                            textStyle: TextStyle(
                                                color: is_dark
                                                    ? Colors.white
                                                    : Colors.black),
                                            inputDecoration:
                                                const InputDecoration(
                                              border: InputBorder.none,
                                            ),
                                            icon: const Icon(
                                              Icons.arrow_drop_down,
                                              color: Colors.grey,
                                              size: 30,
                                            ),
                                            onChangedMonth: (newMonth) {
                                              chart_vm.onChangedMonth(newMonth);
                                            },
                                            onChangedYear: (newYear) {
                                              chart_vm
                                                  .onChangedMonthYear(newYear);
                                            },
                                            showDay: false,
                                            yearFlex: 2,
                                            monthFlex: 3)
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                                right: 80.0),
                                            child: DropdownDatePicker(
                                              width: 80,
                                              selectedYear: chart_vm.year,
                                              boxDecoration: BoxDecoration(
                                                color: is_dark
                                                    ? Colors.transparent
                                                    : Colors.white,
                                              ),
                                              textStyle: TextStyle(
                                                  color: is_dark
                                                      ? Colors.white
                                                      : Colors.black),
                                              inputDecoration:
                                                  const InputDecoration(
                                                border: InputBorder.none,
                                              ),
                                              icon: const Icon(
                                                Icons.arrow_drop_down,
                                                color: Colors.grey,
                                                size: 30,
                                              ),
                                              onChangedYear: (newYear) {
                                                chart_vm.onChangedYear(newYear);
                                              },
                                              showDay: false,
                                              showMonth: false,
                                            ),
                                          )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Container(
                                  width: width,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: is_dark
                                              ? Colors.orange
                                              : Colors.amber),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${LocaleData.income.getString(context)}: ',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        '+$format_income',
                                        style: const TextStyle(
                                            color: Colors.green,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                        overflow: TextOverflow.clip,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 8.0, top: 8),
                                child: Container(
                                  width: width,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: is_dark
                                              ? Colors.orange
                                              : Colors.amber),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${LocaleData.expense.getString(context)}: ',
                                        style: const TextStyle(
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
                                ),
                              ),
                              Container(
                                width: width,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: is_dark
                                            ? Colors.orange
                                            : Colors.amber),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        LocaleData.total_saving
                                            .getString(context),
                                        style: const TextStyle(
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
                          padding: const EdgeInsets.only(top: 220),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom:
                                            BorderSide(color: Colors.grey))),
                                child: CustomSlidingSegmentedControl<int>(
                                  initialValue: 2,
                                  fixedWidth: width * 0.5,
                                  innerPadding: const EdgeInsets.all(0),
                                  children: {
                                    1: Text(
                                      LocaleData.income.getString(context),
                                      style: TextStyle(
                                          color: chart_vm.is_income!
                                              ? (is_dark
                                                  ? Colors.white
                                                  : Colors.black)
                                              : Colors.grey,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16),
                                    ),
                                    2: Text(
                                      LocaleData.expense.getString(context),
                                      style: TextStyle(
                                          color: chart_vm.is_income!
                                              ? Colors.grey
                                              : (is_dark
                                                  ? Colors.white
                                                  : Colors.black),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16),
                                    ),
                                  },
                                  decoration: BoxDecoration(
                                    color: is_dark
                                        ? Colors.transparent
                                        : CupertinoColors.white,
                                  ),
                                  thumbDecoration: BoxDecoration(
                                    color: is_dark
                                        ? Colors.grey[700]
                                        : Colors.white,
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 1.5,
                                            color: is_dark
                                                ? Colors.white
                                                : Colors.black)),
                                  ),
                                  curve: Curves.linear,
                                  onValueChanged: (value) {
                                    if (value == 1) {
                                      setState(() {
                                        chart_vm.is_income = true;
                                      });
                                    }
                                    if (value == 2) {
                                      setState(() {
                                        chart_vm.is_income = false;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 240.0),
                          child: SizedBox(
                            height: 280,
                            child: chart_vm.is_loading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : SfCircularChart(
                                    tooltipBehavior: chart_vm.tooltipBehavior,
                                    series: <CircularSeries>[
                                      DoughnutSeries<Map<String, dynamic>,
                                          String>(
                                        dataSource: chart_vm.is_income!
                                            ? chart_vm.income_categories
                                            : chart_vm.expense_categories,
                                        xValueMapper: (datum, _) =>
                                            datum['name'],
                                        yValueMapper: (datum, _) =>
                                            datum['money'],
                                        dataLabelMapper: (datum, _) =>
                                            datum['name'],
                                        dataLabelSettings:
                                            const DataLabelSettings(
                                                isVisible: true),
                                        enableTooltip: true,
                                        animationDuration: 1000,
                                        explode: true,
                                      )
                                    ],
                                  ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 490),
                            child: chart_vm.is_loading
                                ? ListView.builder(
                                    padding: const EdgeInsets.all(8),
                                    shrinkWrap: true,
                                    itemCount: 5,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Shimmer.fromColors(
                                        baseColor: is_dark
                                            ? Colors.grey[700]!
                                            : Colors.grey[300]!,
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
                                    itemCount: (chart_vm.is_income!
                                            ? chart_vm.income_categories
                                            : chart_vm.expense_categories)
                                        .length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final cat_item = chart_vm.is_income!
                                          ? chart_vm.income_categories[index]
                                          : chart_vm.expense_categories[index];

                                      bool isOverLimit =
                                          cat_item['is_overlimit'] ?? false;

                                      String money_format =
                                          formatter.format(cat_item['money']);

                                      return InkWell(
                                        onTap: () {
                                          if (widget.is_monthly) {
                                            chart_vm.details_cat_item(
                                                cat_item['cat_id'],
                                                cat_item['over'] ?? 0,
                                                chart_vm.month_year_formated,
                                                chart_vm.is_income!,
                                                widget.is_monthly,
                                                context);
                                          } else {
                                            chart_vm.details_cat_item(
                                                cat_item['cat_id'],
                                                cat_item['over'] ?? 0,
                                                chart_vm.year.toString(),
                                                chart_vm.is_income!,
                                                widget.is_monthly,
                                                context);
                                          }
                                        },
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.black,
                                                  width: 0),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15.0,
                                                right: 15,
                                                top: 8,
                                                bottom: 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                    isOverLimit
                                                        ? Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10),
                                                            child: Icon(
                                                              Icons.warning,
                                                              color:
                                                                  Colors.orange,
                                                            ),
                                                          )
                                                        : SizedBox()
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      '${chart_vm.is_income! ? '+' : '-'} $money_format',
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                    const Icon(
                                                        Icons.navigate_next)
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
