import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:money_mate/l10n/app_localizations.dart';
import 'package:money_mate/bloc/chart/chart_cubit.dart';
import 'package:money_mate/bloc/chart/chart_state.dart';
import 'package:money_mate/widget/chart/chart_item_detail.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:money_mate/widget/common/month_year_picker_sheet.dart';

class ChartWidget extends StatefulWidget {
  const ChartWidget({super.key});

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final locale = Localizations.localeOf(context).toString();
    return BlocBuilder<ChartCubit, ChartState>(
      builder: (context, state) {
        final selectedDateText = DateFormat(
          'MM/yyyy',
        ).format(DateTime(state.year, state.month));
        var formatter = NumberFormat.simpleCurrency(locale: locale);

        final currentTransactions = state.isIncome
            ? state.incomeTransactions
            : state.expenseTransactions;

        // Aggregate by category
        final Map<String, Map<String, dynamic>> aggregated = {};
        for (var tx in currentTransactions) {
          final catId = tx.catId;
          final catName = tx.category?.name ?? 'Unknown';
          final catIcon = tx.category?.icon ?? '💰';
          if (!aggregated.containsKey(catId)) {
            aggregated[catId] = {
              'catId': catId,
              'name': catName,
              'icon': catIcon,
              'money': 0.0,
            };
          }
          aggregated[catId]!['money'] += tx.money;
        }
        final currentData = aggregated.values.toList();

        final totalIncome = state.incomeTransactions.fold(
          0.0,
          (s, e) => s + e.money,
        );
        final totalExpense = state.expenseTransactions.fold(
          0.0,
          (s, e) => s + e.money,
        );

        String formatTotal = formatter.format(
          state.isMonthly ? (totalIncome - totalExpense) : 0,
        );
        String formatIncome = formatter.format(totalIncome);
        String formatExpense = formatter.format(totalExpense);

        return Scaffold(
          body: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 70),
                    child: Column(
                      children: [
                        _buildDatePickers(
                          context,
                          state,
                          isDark,
                          width,
                          selectedDateText,
                        ),
                        _buildSummaryCards(
                          context,
                          state,
                          isDark,
                          width,
                          formatIncome,
                          formatExpense,
                          formatTotal,
                        ),
                        _buildSegmentControl(context, state, isDark, width),
                        _buildChart(context, state, currentData),
                        _buildDetailsList(
                          context,
                          state,
                          currentData,
                          isDark,
                          formatter,
                        ),
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
    BuildContext context,
    ChartState state,
    bool isDark,
    double width,
    String selectedDateText,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () => MonthYearPickerSheet.show(
          context,
          initialMonth: state.month,
          initialYear: state.year,
          onConfirm: (month, year) {
            context.read<ChartCubit>().changeMonth(month);
            context.read<ChartCubit>().changeYear(year);
          },
        ),
        child: Container(
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            border: Border.all(
              color: isDark ? Colors.orange : Colors.amber,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_month,
                    color: isDark ? Colors.orange : Colors.amber,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    selectedDateText,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.arrow_drop_down,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards(
    BuildContext context,
    ChartState state,
    bool isDark,
    double width,
    String inc,
    String exp,
    String tot,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          _buildRow(
            AppLocalizations.of(context)!.income,
            inc,
            Colors.green,
            isDark,
          ),
          _buildRow(
            AppLocalizations.of(context)!.expense,
            exp,
            Colors.red,
            isDark,
          ),
          _buildRow(
            AppLocalizations.of(context)!.totalSaving,
            tot,
            isDark ? Colors.white : Colors.black,
            isDark,
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    String label,
    String value,
    Color valColor,
    bool isDark, {
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: isDark ? Colors.orange : Colors.amber),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            Text(
              value,
              style: TextStyle(
                color: valColor,
                fontSize: isBold ? 18 : 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentControl(
    BuildContext context,
    ChartState state,
    bool isDark,
    double width,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey)),
            ),
            child: CustomSlidingSegmentedControl<int>(
              initialValue: state.isIncome ? 1 : 2,
              fixedWidth: width * 0.45,
              innerPadding: EdgeInsets.zero,
              children: {
                1: Text(
                  AppLocalizations.of(context)!.income,
                  style: TextStyle(
                    color: state.isIncome
                        ? (isDark ? Colors.white : Colors.black)
                        : Colors.grey,
                  ),
                ),
                2: Text(
                  AppLocalizations.of(context)!.expense,
                  style: TextStyle(
                    color: !state.isIncome
                        ? (isDark ? Colors.white : Colors.black)
                        : Colors.grey,
                  ),
                ),
              },
              decoration: const BoxDecoration(color: Colors.transparent),
              thumbDecoration: BoxDecoration(
                color: isDark ? Colors.grey[700] : Colors.white,
                border: Border(
                  bottom: BorderSide(
                    width: 1.5,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
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
    BuildContext context,
    ChartState state,
    List<Map<String, dynamic>> data,
  ) {
    if (state.status == ChartStatus.loading) {
      return const SizedBox(
        height: 280,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return SizedBox(
      height: 280,
      child: SfCircularChart(
        series: <CircularSeries>[
          DoughnutSeries<Map<String, dynamic>, String>(
            dataSource: data,
            xValueMapper: (d, _) => d['name'] as String,
            yValueMapper: (d, _) => d['money'] as double,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            enableTooltip: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsList(
    BuildContext context,
    ChartState state,
    List<Map<String, dynamic>> data,
    bool isDark,
    NumberFormat fmt,
  ) {
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
                  catId: item['catId'] as String,
                  isIncome: state.isIncome,
                  isMonthly: state.isMonthly,
                  date: state.isMonthly
                      ? DateFormat(
                          'MMMM yyyy',
                        ).format(DateTime(state.year, state.month))
                      : state.year.toString(),
                ),
              ),
            );
          },
          leading: Text(
            item['icon'] as String,
            style: const TextStyle(fontSize: 28),
          ),
          title: Text(item['name'] as String),
          trailing: Text(
            '${state.isIncome ? '+' : '-'} ${fmt.format(item['money'] as double)}',
          ),
        );
      },
    );
  }
}
