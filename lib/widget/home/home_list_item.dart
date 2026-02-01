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
import 'package:money_mate/widget/common/confirm_delete_dialog.dart';
import 'package:money_mate/widget/common/item_action_menu.dart';

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

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.status == HomeStatus.loading) {
          return _buildShimmer(isDark);
        }

        if (state.allTransactions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 200), // Space for Appbar + Cards
                Icon(
                  Icons.receipt_long_rounded,
                  size: 80,
                  color: isDark ? Colors.white24 : Colors.grey[300],
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.noInputData,
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.grey[600],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
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

        return ListView.builder(
          itemCount: sortedDates.length,
          padding: const EdgeInsets.only(top: 340, bottom: 20),
          itemBuilder: (BuildContext context, int index) {
            final date = sortedDates[index];
            final transactions = dateGroup[date]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 16,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white : Colors.black,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormatUtils.formatDisplayDate(date),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white70 : Colors.grey[800],
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
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
                            ConfirmDeleteDialog.show(
                              context,
                              title: AppLocalizations.of(context)!.slideDelete,
                              content: AppLocalizations.of(
                                context,
                              )!.deleteTransactionConfirm,
                              onConfirm: () {
                                context.read<HomeCubit>().deleteTransaction(
                                  transaction.id,
                                );
                              },
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
                      onLongPress: () {
                        ItemActionMenu.show(
                          context,
                          onEdit: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    UpdateInput(inputItem: transaction),
                              ),
                            );
                          },
                          onDelete: () {
                            ConfirmDeleteDialog.show(
                              context,
                              title: AppLocalizations.of(context)!.slideDelete,
                              content: AppLocalizations.of(
                                context,
                              )!.deleteTransactionConfirm,
                              onConfirm: () {
                                context.read<HomeCubit>().deleteTransaction(
                                  transaction.id,
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  );
                }),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildShimmer(bool isDark) {
    return ListView.builder(
      itemCount: 5,
      padding: const EdgeInsets.only(top: 340, bottom: 16, left: 16, right: 16),
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
    );
  }
}
