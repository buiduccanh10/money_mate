import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:datepicker_dropdown/datepicker_dropdown.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:money_mate/services/locales.dart';
import 'package:money_mate/bloc/chart/chart_cubit.dart';
import 'package:money_mate/bloc/chart/chart_state.dart';
import 'package:money_mate/widget/chart/chart_item_detail.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:shimmer/shimmer.dart';

class ChartWidget extends StatelessWidget {
  const ChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final locale = FlutterLocalization.instance.currentLocale.toString();

    return BlocBuilder<ChartCubit, ChartState>(
      builder: (context, state) {
        var formatter = NumberFormat.simpleCurrency(locale: locale);

        // Simple totals calculation for current filtered data
        final currentData =
            state.isIncome ? state.incomeData : state.expenseData;

        // These would normally come from the state/repo
        String formatTotal = formatter.format(state.isMonthly
            ? (state.incomeData.fold(0.0, (s, e) => s + (e['money'] ?? 0)) -
                state.expenseData.fold(0.0, (s, e) => s + (e['money'] ?? 0)))
            : 0);
        String formatIncome = formatter.format(
            state.incomeData.fold(0.0, (s, e) => s + (e['money'] ?? 0)));
        String formatExpense = formatter.format(
            state.expenseData.fold(0.0, (s, e) => s + (e['money'] ?? 0)));

        return Scaffold(
          body: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 70),
                    child: Column(
                      children: [
                        _buildDatePickers(context, state, isDark, width),
                        _buildSummaryCards(context, state, isDark, width,
                            formatIncome, formatExpense, formatTotal),
                        _buildSegmentControl(context, state, isDark, width),
                        _buildChart(context, state, currentData),
                        _buildDetailsList(
                            context, state, currentData, isDark, formatter),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDatePickers(
      BuildContext context, ChartState state, bool isDark, double width) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: width,
        decoration: BoxDecoration(
            border: Border.all(color: isDark ? Colors.orange : Colors.amber),
            borderRadius: BorderRadius.circular(10)),
        child: SizedBox(
          height: 50,
          child: DropdownDatePicker(
            width: state.isMonthly ? 0 : 80,
            selectedMonth: state.month,
            selectedYear: state.year,
            boxDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.transparent),
            textStyle: TextStyle(color: isDark ? Colors.white : Colors.black),
            inputDecoration: const InputDecoration(border: InputBorder.none),
            icon:
                const Icon(Icons.arrow_drop_down, color: Colors.grey, size: 30),
            onChangedMonth: (val) => val != null
                ? context.read<ChartCubit>().changeMonth(int.parse(val))
                : null,
            onChangedYear: (val) => val != null
                ? context.read<ChartCubit>().changeYear(int.parse(val))
                : null,
            showDay: false,
            showMonth: state.isMonthly,
            yearFlex: 2,
            monthFlex: 3,
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context, ChartState state, bool isDark,
      double width, String inc, String exp, String tot) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          _buildRow(
              LocaleData.income.getString(context), inc, Colors.green, isDark),
          _buildRow(
              LocaleData.expense.getString(context), exp, Colors.red, isDark),
          _buildRow(LocaleData.totalSaving.getString(context), tot,
              isDark ? Colors.white : Colors.black, isDark,
              isBold: true),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, Color valColor, bool isDark,
      {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            border: Border.all(color: isDark ? Colors.orange : Colors.amber),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            Text(value,
                style: TextStyle(
                    color: valColor,
                    fontSize: isBold ? 18 : 14,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentControl(
      BuildContext context, ChartState state, bool isDark, double width) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey))),
            child: CustomSlidingSegmentedControl<int>(
              initialValue: state.isIncome ? 1 : 2,
              fixedWidth: width * 0.45,
              innerPadding: EdgeInsets.zero,
              children: {
                1: Text(LocaleData.income.getString(context),
                    style: TextStyle(
                        color: state.isIncome
                            ? (isDark ? Colors.white : Colors.black)
                            : Colors.grey)),
                2: Text(LocaleData.expense.getString(context),
                    style: TextStyle(
                        color: !state.isIncome
                            ? (isDark ? Colors.white : Colors.black)
                            : Colors.grey)),
              },
              decoration: BoxDecoration(color: Colors.transparent),
              thumbDecoration: BoxDecoration(
                color: isDark ? Colors.grey[700] : Colors.white,
                border: Border(
                    bottom: BorderSide(
                        width: 1.5,
                        color: isDark ? Colors.white : Colors.black)),
              ),
              onValueChanged: (v) =>
                  context.read<ChartCubit>().toggleIncome(v == 1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(
      BuildContext context, ChartState state, List<Map<String, dynamic>> data) {
    if (state.status == ChartStatus.loading) {
      return const SizedBox(
          height: 280, child: Center(child: CircularProgressIndicator()));
    }
    return SizedBox(
      height: 280,
      child: SfCircularChart(
        series: <CircularSeries>[
          DoughnutSeries<Map<String, dynamic>, String>(
            dataSource: data,
            xValueMapper: (d, _) => d['name'],
            yValueMapper: (d, _) => d['money'],
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            enableTooltip: true,
          )
        ],
      ),
    );
  }

  Widget _buildDetailsList(BuildContext context, ChartState state,
      List<Map<String, dynamic>> data, bool isDark, NumberFormat fmt) {
    if (state.status == ChartStatus.loading) {
      return Shimmer.fromColors(
        baseColor: isDark ? Colors.grey[700]! : Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(height: 200, color: Colors.white),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        return ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChartItemDetail(
                          catId: item['catId'],
                          isIncome: state.isIncome,
                          isMonthly: state.isMonthly,
                          date: state.isMonthly
                              ? DateFormat('MMMM yyyy')
                                  .format(DateTime(state.year, state.month))
                              : state.year.toString(),
                        )));
          },
          leading: Text(item['icon'], style: const TextStyle(fontSize: 28)),
          title: Text(item['name']),
          trailing: Text(
              '${state.isIncome ? '+' : '-'} ${fmt.format(item['money'])}'),
        );
      },
    );
  }
}
