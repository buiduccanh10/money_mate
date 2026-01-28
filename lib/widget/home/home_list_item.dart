import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_mate/l10n/app_localizations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:money_mate/bloc/home/home_cubit.dart';
import 'package:money_mate/bloc/home/home_state.dart';
import 'package:money_mate/widget/input/update_input.dart';
import 'package:money_mate/widget/common/transaction_item_tile.dart';
import 'package:money_mate/data/network/swagger/generated/money_mate_api.swagger.dart';
import 'package:shimmer/shimmer.dart';
import 'package:money_mate/utils/date_format_utils.dart';

class HomeListItem extends StatefulWidget {
  const HomeListItem({super.key});

  @override
  State<HomeListItem> createState() => _HomeListItemState();
}

class _HomeListItemState extends State<HomeListItem> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().fetchData();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.status == HomeStatus.loading) {
          return _buildShimmer(isDark);
        }

        if (state.allTransactions.isEmpty) {
          return Expanded(
            child: Center(
              child: Text(AppLocalizations.of(context)!.noInputData),
            ),
          );
        }

        final data = state.allTransactions;
        final dateGroup = <String, List<TransactionResponseDto>>{};
        List<String> sortedDates = [];

        for (final item in data) {
          final date = item.date;
          dateGroup.putIfAbsent(date, () => []);
          dateGroup[date]!.add(item);
        }

        sortedDates = dateGroup.keys.toList()..sort((a, b) => b.compareTo(a));

        return Expanded(
          child: ListView.builder(
            itemCount: sortedDates.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              final date = sortedDates[index];
              final transactions = dateGroup[date]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: width,
                    padding: const EdgeInsets.only(left: 10, top: 8, bottom: 8),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[700] : Colors.grey[200],
                    ),
                    child: Text(
                      DateFormatUtils.formatDisplayDate(date),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...transactions.map((transaction) {
                    return Slidable(
                      key: ValueKey(transaction.id),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            backgroundColor: Colors.transparent,
                            onPressed: (context) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      UpdateInput(inputItem: transaction),
                                ),
                              );
                            },
                            foregroundColor: const Color(0xFF2196F3),
                            icon: Icons.edit,
                            label: AppLocalizations.of(context)!.slideEdit,
                          ),
                          SlidableAction(
                            backgroundColor: Colors.transparent,
                            onPressed: (context) {
                              context.read<HomeCubit>().deleteTransaction(
                                transaction.id,
                              );
                            },
                            foregroundColor: Colors.red,
                            icon: Icons.delete,
                            label: AppLocalizations.of(context)!.slideDelete,
                          ),
                        ],
                      ),
                      child: TransactionItemTile(
                        transaction: transaction,
                        isDark: isDark,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  UpdateInput(inputItem: transaction),
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildShimmer(bool isDark) {
    return Expanded(
      child: ListView.builder(
        itemCount: 5,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Shimmer.fromColors(
              baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
              highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Container(height: 20, color: Colors.white)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
