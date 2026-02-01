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
import 'package:money_mate/widget/common/category_icon_circle.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(20), // STYLE_GUIDE: Radius 20
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: 0.04,
              ), // STYLE_GUIDE: Shadow
              blurRadius: 15,
              offset: const Offset(0, 8),
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
            1: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                AppLocalizations.of(context)!.income,
                style: TextStyle(
                  color: state.isIncome
                      ? Colors.white
                      : (isDark ? Colors.white54 : Colors.black54),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            2: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                AppLocalizations.of(context)!.expense,
                style: TextStyle(
                  color: !state.isIncome
                      ? Colors.white
                      : (isDark ? Colors.white54 : Colors.black54),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          },
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(50),
            border: isDark
                ? Border.all(color: Colors.white.withValues(alpha: 0.1))
                : null,
          ),
          thumbDecoration: BoxDecoration(
            color: state.isIncome
                ? const Color(0xFF00C853) // Income Green
                : const Color(0xFFFF3D00), // Expense Red
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color:
                    (state.isIncome
                            ? const Color(0xFF00C853)
                            : const Color(0xFFFF3D00))
                        .withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;

    if (state.status == ChartStatus.loading) {
      return Shimmer.fromColors(
        baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
        highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
        child: Container(
          margin: const EdgeInsets.all(16),
          height: 280,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );
    }

    if (data.isEmpty) {
      return Container(
        margin: const EdgeInsets.all(16),
        height: 280,
        width: width * 0.92,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Opacity(
                opacity: 0.3,
                child: Icon(
                  Icons.pie_chart_outline_rounded,
                  size: 80,
                  color: isDark ? Colors.white : Colors.grey,
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

    return Container(
      margin: const EdgeInsets.all(16),
      height: 250,
      width: width * 0.92,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SfCircularChart(
        palette: const <Color>[
          Color(0xFF4364F7),
          Color(0xFF00C853),
          Color(0xFFFF3D00),
          Color(0xFFFFD600),
          Color(0xFF6FB1FC),
          Color(0xFF7C4DFF),
          Color(0xFF00B8D4),
          Color(0xFF64DD17),
        ],
        series: <CircularSeries>[
          DoughnutSeries<Map<String, dynamic>, String>(
            dataSource: data,
            xValueMapper: (d, _) => d['name'] as String,
            yValueMapper: (d, _) => d['money'] as double,
            innerRadius: '60%',
            radius: '70%',
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.outside,
              textStyle: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
            enableTooltip: true,
          ),
        ],
        legend: const Legend(
          isVisible: true,
          position: LegendPosition.bottom,
          overflowMode: LegendItemOverflowMode.wrap,
        ),
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
      return _buildDetailsShimmer(isDark);
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        final color = state.isIncome
            ? const Color(0xFF00C853)
            : const Color(0xFFFF3D00);

        return InkWell(
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
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                CategoryIconCircle(
                  icon: item['icon'] as String,
                  isDark: isDark,
                  radius: 26,
                  iconSize: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item['name'] as String,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 4,
                  children: [
                    Text(
                      '${state.isIncome ? '+' : '-'} ${fmt.format(item['money'] as double)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailsShimmer(bool isDark) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Shimmer.fromColors(
            baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
            highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 16, color: Colors.white, width: 120),
                      const SizedBox(height: 8),
                      Container(height: 12, color: Colors.white, width: 80),
                    ],
                  ),
                ),
                Container(height: 16, color: Colors.white, width: 60),
              ],
            ),
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
