import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:money_mate/services/locales.dart';
import 'package:money_mate/bloc/search/search_cubit.dart';
import 'package:money_mate/bloc/search/search_state.dart';
import 'package:money_mate/bloc/category/category_cubit.dart';
import 'package:money_mate/bloc/category/category_state.dart';
import 'package:money_mate/widget/input/update_input.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final locale = FlutterLocalization.instance.currentLocale.toString();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Column(
            children: [
              SearchBar(
                padding: const WidgetStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 16.0),
                ),
                onChanged: (query) {
                  _debounce?.cancel();
                  _debounce = Timer(const Duration(milliseconds: 500), () {
                    context.read<SearchCubit>().searchTransactions(query);
                  });
                },
                hintText: LocaleData.typeAnyToSearch.getString(context),
                leading: const Icon(Icons.search, size: 28),
              ),
              const SizedBox(height: 20),
              _buildCategoryChips(isDark),
              const SizedBox(height: 20),
              _buildResults(locale, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips(bool isDark) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        final categories = [
          ...state.incomeCategories,
          ...state.expenseCategories,
        ];
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: categories.map((cat) {
            return InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => context.read<SearchCubit>().searchByCategory(cat.id),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors
                      .primaries[Random().nextInt(Colors.primaries.length)]
                      .shade100
                      .withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(cat.icon, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 4),
                    Text(cat.name),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildResults(String locale, bool isDark) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state.status == SearchStatus.loading) {
          return const Expanded(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.searchResults.isEmpty) {
          return Image.asset('assets/search.png', width: 250);
        }

        return Expanded(
          child: ListView.builder(
            itemCount: state.searchResults.length,
            itemBuilder: (context, index) {
              final result = state.searchResults[index];
              final formatter = NumberFormat.simpleCurrency(locale: locale);
              final String formatMoney = formatter.format(result.money);

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
                            builder: (_) => UpdateInput(inputItem: result),
                          ),
                        );
                      },
                      foregroundColor: Colors.blue,
                      icon: Icons.edit,
                      label: LocaleData.slideEdit.getString(context),
                    ),
                    SlidableAction(
                      backgroundColor: Colors.transparent,
                      onPressed: (context) {
                        // Handle delete within SearchCubit if needed
                      },
                      foregroundColor: Colors.red,
                      icon: Icons.delete,
                      label: LocaleData.slideDelete.getString(context),
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UpdateInput(inputItem: result),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 24,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            _buildIconCircle(
                              result.category?.icon ?? '💰',
                              isDark,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  result.description ?? '',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  result.date,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${result.isIncome ? '+' : '-'} $formatMoney',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: result.isIncome
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            Text(
                              result.category?.name ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildIconCircle(String icon, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.3),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: const Offset(-5, 5),
                ),
              ],
        borderRadius: BorderRadius.circular(50),
      ),
      child: CircleAvatar(
        backgroundColor: Colors
            .primaries[Random().nextInt(Colors.primaries.length)]
            .shade100
            .withValues(alpha: 0.35),
        radius: 28,
        child: Text(icon, style: const TextStyle(fontSize: 38)),
      ),
    );
  }
}
