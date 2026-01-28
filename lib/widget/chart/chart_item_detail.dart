import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:money_mate/l10n/app_localizations.dart';
import 'package:money_mate/bloc/chart/chart_cubit.dart';
import 'package:money_mate/bloc/chart/chart_state.dart';
import 'package:money_mate/utils/date_format_utils.dart';
import 'package:money_mate/widget/input/update_input.dart';
import 'package:money_mate/data/network/swagger/generated/money_mate_api.swagger.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:money_mate/widget/common/transaction_item_tile.dart';

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
    context.read<ChartCubit>().fetchDetail(
      isMonthly: widget.isMonthly,
      isIncome: widget.isIncome,
      date: widget.date,
      catId: widget.catId,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final locale = Localizations.localeOf(context).toString();

    return BlocBuilder<ChartCubit, ChartState>(
      builder: (context, state) {
        final data = state.detailData;
        final dateGroup = <String, List<TransactionResponseDto>>{};
        List<String> sortedDates = [];

        for (final item in data) {
          final date = item.date;
          final key = widget.isMonthly ? date : date.substring(3);
          dateGroup.putIfAbsent(key, () => []);
          dateGroup[key]!.add(item);
        }

        sortedDates = dateGroup.keys.toList()
          ..sort(
            (a, b) =>
                (widget.isMonthly
                        ? DateFormat('dd/MM/yyyy')
                        : DateFormat('MM/yyyy'))
                    .parse(b)
                    .compareTo(
                      (widget.isMonthly
                              ? DateFormat('dd/MM/yyyy')
                              : DateFormat('MM/yyyy'))
                          .parse(a),
                    ),
          );

        final formatter = NumberFormat.simpleCurrency(locale: locale);
        String appBarTitle = data.isNotEmpty
            ? (data.first.category?.name ?? '')
            : AppLocalizations.of(context)!.noInputData;
        if (widget.over > 0) {
          appBarTitle +=
              ': ${AppLocalizations.of(context)!.over} ${formatter.format(widget.over)}';
        }

        return Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          const Color.fromARGB(255, 203, 122, 0),
                          const Color.fromARGB(255, 0, 112, 204),
                        ]
                      : [Colors.orange, Colors.blue],
                ),
              ),
            ),
            leading: const BackButton(color: Colors.white),
            title: Text(
              appBarTitle,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: state.status == ChartStatus.loading
                    ? const Center(child: CircularProgressIndicator())
                    : data.isEmpty
                    ? Center(
                        child: Text(AppLocalizations.of(context)!.noInputData),
                      )
                    : Column(
                        children: [
                          _buildChart(sortedDates, dateGroup),
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              itemCount: sortedDates.length,
                              itemBuilder: (context, index) {
                                final date = sortedDates[index];
                                final transactions = dateGroup[date]!;
                                return _buildDateSection(
                                  context,
                                  isDark,
                                  date,
                                  transactions,
                                );
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

  Widget _buildChart(
    List<String> sortedDates,
    Map<String, List<TransactionResponseDto>> dateGroup,
  ) {
    final List<Map<String, dynamic>> chartData = sortedDates.reversed.map((
      date,
    ) {
      final total = dateGroup[date]!.fold<double>(
        0,
        (prev, item) => prev + item.money,
      );
      return <String, dynamic>{'date': date, 'money': total};
    }).toList();

    return SizedBox(
      height: 250,
      child: SfCartesianChart(
        primaryXAxis: const CategoryAxis(),
        series: <CartesianSeries<Map<String, dynamic>, String>>[
          ColumnSeries<Map<String, dynamic>, String>(
            dataSource: chartData,
            xValueMapper: (d, _) => d['date'] as String,
            yValueMapper: (d, _) => d['money'] as double,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            pointColorMapper: (d, _) =>
                Colors.primaries[chartData.indexOf(d) %
                    Colors.primaries.length],
          ),
        ],
      ),
    );
  }

  Widget _buildDateSection(
    BuildContext context,
    bool isDark,
    String date,
    List<TransactionResponseDto> transactions,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          color: isDark ? Colors.grey[800] : Colors.grey[200],
          child: Text(
            DateFormatUtils.formatDisplayDate(date),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        ...transactions.map((tx) => _buildTransactionItem(context, isDark, tx)),
      ],
    );
  }

  Widget _buildTransactionItem(
    BuildContext context,
    bool isDark,
    TransactionResponseDto tx,
  ) {
    return Slidable(
      key: ValueKey(tx.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => _editTx(tx),
            icon: Icons.edit,
            label: 'Edit',
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.blue,
          ),
          SlidableAction(
            onPressed: (_) {
              // Handle delete if needed
            },
            icon: Icons.delete,
            label: 'Delete',
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.red,
          ),
        ],
      ),
      child: TransactionItemTile(
        transaction: tx,
        isDark: isDark,
        onTap: () => _editTx(tx),
      ),
    );
  }

  void _editTx(TransactionResponseDto tx) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => UpdateInput(inputItem: tx)),
    );
  }
}
