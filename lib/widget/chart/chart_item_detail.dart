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
import 'package:money_mate/widget/common/confirm_delete_dialog.dart';
import 'package:money_mate/widget/common/item_action_menu.dart';

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
          DateTime dt;
          try {
            dt = DateFormat('yyyy-MM-dd').parse(item.date);
          } catch (_) {
            dt = DateFormat('dd/MM/yyyy').parse(item.date);
          }

          final key = widget.isMonthly
              ? DateFormat('dd/MM/yyyy').format(dt)
              : DateFormat('MM/yyyy').format(dt);

          dateGroup.putIfAbsent(key, () => []);
          dateGroup[key]!.add(item);
        }

        sortedDates = dateGroup.keys.toList()
          ..sort((a, b) {
            final formatter = widget.isMonthly
                ? DateFormat('dd/MM/yyyy')
                : DateFormat('MM/yyyy');
            return formatter.parse(b).compareTo(formatter.parse(a));
          });

        final formatter = NumberFormat.simpleCurrency(locale: locale);
        String appBarTitle = data.isNotEmpty
            ? (data.first.category?.name ?? '')
            : AppLocalizations.of(context)!.noInputData;
        if (widget.over > 0) {
          appBarTitle +=
              ': ${AppLocalizations.of(context)!.over} ${formatter.format(widget.over)}';
        }

        return Scaffold(
          backgroundColor: isDark
              ? const Color(0xFF121212)
              : const Color(0xFFF5F7FA),
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          const Color(0xFF0F2027),
                          const Color(0xFF203A43),
                          const Color(0xFF2C5364),
                        ]
                      : [const Color(0xFF4364F7), const Color(0xFF6FB1FC)],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: const BackButton(color: Colors.white),
            title: Text(
              appBarTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
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
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 16,
                              ),
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
    // ... (Chart logic remains same, just ensuring padding/container)
    final List<Map<String, dynamic>> chartData = sortedDates.reversed.map((
      date,
    ) {
      final total = dateGroup[date]!.fold<double>(
        0,
        (prev, item) => prev + item.money,
      );
      return <String, dynamic>{'date': date, 'money': total};
    }).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: SizedBox(
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
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
          ],
        ),
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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              DateFormatUtils.formatDisplayDate(date),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ),
        ...transactions.map(
          (tx) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: _buildTransactionItem(context, isDark, tx),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem(
    BuildContext context,
    bool isDark,
    TransactionResponseDto tx,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: Slidable(
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
                onPressed: (slidableContext) {
                  final chartCubit = context.read<ChartCubit>();
                  ConfirmDeleteDialog.show(
                    context,
                    title: AppLocalizations.of(context)!.slideDelete,
                    content: AppLocalizations.of(
                      context,
                    )!.deleteTransactionConfirm,
                    onConfirm: () => chartCubit.deleteTransaction(tx.id),
                  );
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
            onLongPress: () {
              ItemActionMenu.show(
                context,
                onEdit: () => _editTx(tx),
                onDelete: () {
                  ConfirmDeleteDialog.show(
                    context,
                    title: AppLocalizations.of(context)!.slideDelete,
                    content: AppLocalizations.of(
                      context,
                    )!.deleteTransactionConfirm,
                    onConfirm: () =>
                        context.read<ChartCubit>().deleteTransaction(tx.id),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _editTx(TransactionResponseDto tx) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => UpdateInput(inputItem: tx)),
    );
    if (mounted) {
      context.read<ChartCubit>().refreshDetail();
      context.read<ChartCubit>().fetchData();
    }
  }
}
