import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_mate/l10n/app_localizations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:money_mate/bloc/search/search_cubit.dart';
import 'package:money_mate/bloc/search/search_state.dart';
import 'package:money_mate/bloc/category/category_cubit.dart';
import 'package:money_mate/bloc/category/category_state.dart';
import 'package:money_mate/widget/input/update_input.dart';
import 'package:money_mate/widget/common/transaction_item_tile.dart';
import 'dart:async';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    context.read<SearchCubit>().clearSearch();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final locale = Localizations.localeOf(context).toString();

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
                hintText: AppLocalizations.of(context)!.typeAnyToSearch,
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
      builder: (context, catState) {
        return BlocBuilder<SearchCubit, SearchState>(
          builder: (context, searchState) {
            final categories = [
              ...catState.incomeCategories,
              ...catState.expenseCategories,
            ];
            return Wrap(
              spacing: 10,
              runSpacing: 10,
              children: categories.map((cat) {
                final isSelected = searchState.catId == cat.id;
                return InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () =>
                      context.read<SearchCubit>().searchByCategory(cat.id),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors
                          .primaries[cat.name.hashCode %
                              Colors.primaries.length]
                          .shade100
                          .withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? (isDark ? Colors.orange : Colors.amber)
                            : Colors.transparent,
                        width: 2,
                      ),
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
                      label: AppLocalizations.of(context)!.slideEdit,
                    ),
                    SlidableAction(
                      backgroundColor: Colors.transparent,
                      onPressed: (context) {
                        // Handle delete within SearchCubit if needed
                      },
                      foregroundColor: Colors.red,
                      icon: Icons.delete,
                      label: AppLocalizations.of(context)!.slideDelete,
                    ),
                  ],
                ),
                child: TransactionItemTile(
                  transaction: result,
                  isDark: isDark,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UpdateInput(inputItem: result),
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
}
