import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:money_mate/services/locales.dart';
import 'package:money_mate/bloc/home/home_cubit.dart';
import 'package:money_mate/bloc/home/home_state.dart';
import 'package:money_mate/widget/input/update_input.dart';
import 'package:shimmer/shimmer.dart';

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
    final locale = FlutterLocalization.instance.currentLocale.toString();

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.status == HomeStatus.loading) {
          return _buildShimmer(isDark);
        }

        if (state.allTransactions.isEmpty) {
          return Expanded(
            child: Center(
              child: Text(LocaleData.no_input_data.getString(context)),
            ),
          );
        }

        final dateGroup = <String, List<Map<String, dynamic>>>{};
        for (final item in state.allTransactions) {
          final date = item['date'] as String;
          dateGroup.putIfAbsent(date, () => []);
          dateGroup[date]!.add(item);
        }

        final sortedDates = dateGroup.keys.toList()
          ..sort((a, b) => DateFormat('dd/MM/yyyy')
              .parse(b)
              .compareTo(DateFormat('dd/MM/yyyy').parse(a)));

        return Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 24, bottom: 120),
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
                        color: isDark ? Colors.grey[700] : Colors.grey[200]),
                    child: Text(
                      date,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ...transactions.map((transaction) {
                    var formatter = NumberFormat.simpleCurrency(locale: locale);
                    String formatMoney = formatter.format(transaction['money']);
                    return Slidable(
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
                                          UpdateInput(inputItem: transaction)));
                            },
                            foregroundColor: Colors.blue,
                            icon: Icons.edit,
                            label: LocaleData.slide_edit.getString(context),
                          ),
                          SlidableAction(
                            backgroundColor: Colors.transparent,
                            onPressed: (context) {
                              context
                                  .read<HomeCubit>()
                                  .deleteTransaction(transaction['id']);
                            },
                            foregroundColor: Colors.red,
                            icon: Icons.delete,
                            label: LocaleData.slide_delete.getString(context),
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      UpdateInput(inputItem: transaction)));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  _buildCategoryCircle(
                                      transaction['icon'], isDark),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: width * 0.4,
                                          child: Text(
                                            transaction['description'],
                                            softWrap: true,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        Text(
                                          transaction['date'],
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.grey),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${transaction['isIncome'] ? '+' : '-'} $formatMoney',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: transaction['isIncome']
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                  Text(
                                    transaction['name'],
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.grey),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
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

  Widget _buildCategoryCircle(String icon, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: const Offset(-5, 5),
                )
              ],
        borderRadius: BorderRadius.circular(50),
      ),
      child: CircleAvatar(
        backgroundColor: Colors
            .primaries[Random().nextInt(Colors.primaries.length)].shade100
            .withOpacity(0.35),
        radius: 28,
        child: Text(icon, style: const TextStyle(fontSize: 38)),
      ),
    );
  }

  Widget _buildShimmer(bool isDark) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 100),
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return Shimmer.fromColors(
            baseColor: isDark ? Colors.grey[700]! : Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
              child: ListTile(
                title: Container(height: 20, color: Colors.white),
                subtitle: Container(height: 15, color: Colors.white),
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                ),
                trailing: Container(width: 60, height: 20, color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}
