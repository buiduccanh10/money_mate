import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:money_mate/services/locales.dart';
import 'package:money_mate/bloc/chart/chart_cubit.dart';
import 'package:money_mate/bloc/chart/chart_state.dart';
import 'package:money_mate/widget/input/update_input.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartItemDetail extends StatefulWidget {
  final String? catId;
  final String? date;
  final bool? isIncome;
  final bool isMonthly;
  final double over;

  const ChartItemDetail({
    super.key,
    this.catId,
    this.over = 0.0,
    this.date,
    this.isIncome,
    required this.isMonthly,
  });

  @override
  State<ChartItemDetail> createState() => _ChartItemDetailState();
}

class _ChartItemDetailState extends State<ChartItemDetail> {
  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  void _fetchDetail() {
    // context.read<ChartCubit>().fetchDetail(isMonthly: widget.isMonthly, isIncome: widget.isIncome, date: widget.date, catId: widget.catId);
    // For now, using the global chart data if it has what we need, but we likely need a specific fetch.
    // I'll implement fetchDetail in ChartCubit.
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final locale = FlutterLocalization.instance.currentLocale.toString();

    return BlocBuilder<ChartCubit, ChartState>(
      builder: (context, state) {
        final data = state.detailData;
        final dateGroup = <String, List<Map<String, dynamic>>>{};
        List<String> sortedDates = [];

        for (final item in data) {
          final date = item['date'] as String;
          final key = widget.isMonthly ? date : date.substring(3);
          dateGroup.putIfAbsent(key, () => []);
          dateGroup[key]!.add(item);
        }

        sortedDates = dateGroup.keys.toList()
          ..sort((a, b) => (widget.isMonthly
                  ? DateFormat('dd/MM/yyyy')
                  : DateFormat('MM/yyyy'))
              .parse(b)
              .compareTo((widget.isMonthly
                      ? DateFormat('dd/MM/yyyy')
                      : DateFormat('MM/yyyy'))
                  .parse(a)));

        final formatter = NumberFormat.simpleCurrency(locale: locale);

        return Scaffold(
          body: Column(
            children: [
              _buildHeader(isDark, data, formatter),
              Expanded(
                child: state.status == ChartStatus.loading
                    ? const Center(child: CircularProgressIndicator())
                    : data.isEmpty
                        ? Center(
                            child:
                                Text(LocaleData.noInputData.getString(context)))
                        : Column(
                            children: [
                              _buildChart(sortedDates, dateGroup, locale),
                              Expanded(
                                child: ListView.builder(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  itemCount: sortedDates.length,
                                  itemBuilder: (context, index) {
                                    final date = sortedDates[index];
                                    final transactions = dateGroup[date]!;
                                    return _buildDateSection(context, isDark,
                                        date, transactions, locale);
                                  },
                                ),
                              ),
                            ],
                          ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(
      bool isDark, List<Map<String, dynamic>> data, NumberFormat formatter) {
    String title = data.isNotEmpty
        ? data.first['name']
        : LocaleData.noInputData.getString(context);
    if (widget.over > 0) {
      title +=
          ': ${LocaleData.over.getString(context)} ${formatter.format(widget.over)}';
    }

    return Container(
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [Colors.blue[900]!, Colors.orange[900]!]
              : [Colors.orange, Colors.blue],
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            const BackButton(color: Colors.white),
            Expanded(
                child: Text(title,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    overflow: TextOverflow.ellipsis)),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(List<String> sortedDates,
      Map<String, List<Map<String, dynamic>>> dateGroup, String locale) {
    final chartData = sortedDates.reversed.map((date) {
      final total = dateGroup[date]!
          .fold<double>(0, (prev, item) => prev + (item['money'] as double));
      return {'date': date, 'money': total};
    }).toList();

    return SizedBox(
      height: 250,
      child: SfCartesianChart(
        primaryXAxis: const CategoryAxis(),
        series: <CartesianSeries<Map<String, dynamic>, String>>[
          ColumnSeries<Map<String, dynamic>, String>(
            dataSource: chartData,
            xValueMapper: (d, _) => d['date'],
            yValueMapper: (d, _) => d['money'],
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            pointColorMapper: (d, _) =>
                Colors.primaries[Random().nextInt(Colors.primaries.length)],
          ),
        ],
      ),
    );
  }

  Widget _buildDateSection(BuildContext context, bool isDark, String date,
      List<Map<String, dynamic>> transactions, String locale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          color: isDark ? Colors.grey[800] : Colors.grey[200],
          child:
              Text(date, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        ...transactions
            .map((tx) => _buildTransactionItem(context, isDark, tx, locale)),
      ],
    );
  }

  Widget _buildTransactionItem(BuildContext context, bool isDark,
      Map<String, dynamic> tx, String locale) {
    final formatter = NumberFormat.simpleCurrency(locale: locale);
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
              onPressed: (_) => _editTx(tx),
              icon: Icons.edit,
              label: 'Edit',
              foregroundColor: Colors.blue),
          SlidableAction(
              onPressed: (_) => _deleteTx(tx['id']),
              icon: Icons.delete,
              label: 'Delete',
              foregroundColor: Colors.red),
        ],
      ),
      child: ListTile(
        onTap: () => _editTx(tx),
        leading: CircleAvatar(
          backgroundColor: Colors
              .primaries[Random().nextInt(Colors.primaries.length)]
              .withValues(alpha: 0.2),
          child: Text(tx['icon'] ?? '💰'),
        ),
        title: Text(tx['description'] ?? '',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(tx['date']),
        trailing: Text(
          '${tx['isIncome'] ? '+' : '-'} ${formatter.format(tx['money'])}',
          style: TextStyle(
              color: tx['isIncome'] ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _editTx(Map<String, dynamic> tx) {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => UpdateInput(inputItem: tx)));
  }

  void _deleteTx(String id) {
    // context.read<ChartCubit>().deleteTransaction(id);
  }
}
