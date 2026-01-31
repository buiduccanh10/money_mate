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
        final selectedDateText = state.isMonthly
            ? DateFormat('MM/yyyy').format(DateTime(state.year, state.month))
            : state.year.toString();
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

        String formatTotal = formatter.format(totalIncome - totalExpense);
        String formatIncome = formatter.format(totalIncome);
        String formatExpense = formatter.format(totalExpense);

        return Scaffold(
          backgroundColor: isDark
              ? const Color(0xFF121212)
              : const Color(0xFFF5F7FA),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 70),
                    child: Column(
                      children: [
                        ChartDatePicker(
                          state: state,
                          isDark: isDark,
                          width: width,
                          selectedDateText: selectedDateText,
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
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.grey[400] : Colors.grey[700],
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: valColor,
                fontSize: isBold ? 16 : 14,
                fontWeight: FontWeight.bold,
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
      padding: const EdgeInsets.only(top: 20.0, bottom: 10),
      child: Center(
        child: CustomSlidingSegmentedControl<int>(
          initialValue: state.isIncome ? 1 : 2,
          padding: 8,
          children: {
            1: Text(
              AppLocalizations.of(context)!.income,
              style: TextStyle(
                color: state.isIncome
                    ? Colors.white
                    : (isDark ? Colors.white54 : Colors.black54),
                fontWeight: FontWeight.w600,
              ),
            ),
            2: Text(
              AppLocalizations.of(context)!.expense,
              style: TextStyle(
                color: !state.isIncome
                    ? Colors.white
                    : (isDark ? Colors.white54 : Colors.black54),
                fontWeight: FontWeight.w600,
              ),
            ),
          },
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(50),
          ),
          thumbDecoration: BoxDecoration(
            color: state.isIncome
                ? const Color(0xFF00C853) // Income Green
                : const Color(0xFFFF3D00), // Expense Red
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          onValueChanged: (v) =>
              context.read<ChartCubit>().toggleIncome(v == 1),
        ),
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

    if (data.isEmpty) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      return SizedBox(
        height: 280,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Opacity(
                opacity: 0.5,
                child: Image.asset(
                  'assets/search.png',
                  width: 150,
                  color: isDark ? Colors.white38 : null,
                  colorBlendMode: isDark ? BlendMode.srcIn : null,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.noInputData,
                style: TextStyle(
                  color: isDark ? Colors.grey[600] : Colors.grey[400],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
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

class ChartDatePicker extends StatefulWidget {
  final ChartState state;
  final bool isDark;
  final double width;
  final String selectedDateText;

  const ChartDatePicker({
    super.key,
    required this.state,
    required this.isDark,
    required this.width,
    required this.selectedDateText,
  });

  @override
  State<ChartDatePicker> createState() => _ChartDatePickerState();
}

class _ChartDatePickerState extends State<ChartDatePicker> {
  @override
  void initState() {
    super.initState();
    // Initialize state logic if needed
  }

  @override
  void dispose() {
    // Dispose resources if needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      child: GestureDetector(
        onTap: () => MonthYearPickerSheet.show(
          context,
          initialMonth: widget.state.month,
          initialYear: widget.state.year,
          isYearOnly: !widget.state.isMonthly,
          onConfirm: (month, year) {
            context.read<ChartCubit>().changeMonth(month);
            context.read<ChartCubit>().changeYear(year);
          },
        ),
        child: Container(
          width: widget.width,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: widget.isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_month_rounded,
                    color: const Color(0xFF4364F7),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.selectedDateText,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: widget.isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.arrow_drop_down_rounded,
                color: widget.isDark ? Colors.grey[400] : Colors.grey[600],
                size: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
