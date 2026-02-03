import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_mate/l10n/app_localizations.dart';

import 'package:money_mate/bloc/search/search_cubit.dart';
import 'package:money_mate/bloc/search/search_state.dart';
import 'package:money_mate/bloc/category/category_cubit.dart';
import 'package:money_mate/bloc/category/category_state.dart';
import 'package:money_mate/widget/input/update_input.dart';
import 'package:money_mate/widget/common/transaction_item_tile.dart';
import 'package:money_mate/widget/common/confirm_delete_dialog.dart';

import 'package:money_mate/bloc/home/home_cubit.dart';
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
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: SearchBar(
                  padding: const WidgetStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  backgroundColor: WidgetStatePropertyAll(
                    isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  ),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  elevation: const WidgetStatePropertyAll(0),
                  onChanged: (query) {
                    _debounce?.cancel();
                    _debounce = Timer(const Duration(milliseconds: 500), () {
                      context.read<SearchCubit>().searchTransactions(query);
                    });
                  },
                  hintText: AppLocalizations.of(context)!.typeAnyToSearch,
                  hintStyle: WidgetStatePropertyAll(
                    TextStyle(color: isDark ? Colors.grey : Colors.grey[400]),
                  ),
                  leading: Icon(
                    Icons.search,
                    size: 28,
                    color: isDark ? Colors.white70 : Colors.blueAccent,
                  ),
                ),
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
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: Row(
                children: categories.map((cat) {
                  final isSelected = searchState.catId == cat.id;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () =>
                          context.read<SearchCubit>().searchByCategory(cat.id),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? LinearGradient(
                                  colors: isDark
                                      ? [
                                          const Color(0xFF0F2027),
                                          const Color(0xFF2C5364),
                                        ]
                                      : [
                                          const Color(0xFF4364F7),
                                          const Color(0xFF6FB1FC),
                                        ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null,
                          color: isSelected
                              ? null
                              : (isDark
                                    ? const Color(0xFF1E1E1E)
                                    : Colors.white),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected
                                  ? const Color(
                                      0xFF4364F7,
                                    ).withValues(alpha: 0.3)
                                  : Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          border: isSelected
                              ? null
                              : Border.all(
                                  color: isDark
                                      ? Colors.grey[800]!
                                      : Colors.grey[200]!,
                                ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              cat.icon,
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              cat.name,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : (isDark
                                          ? Colors.grey[300]
                                          : Colors.grey[800]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
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
          return Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/search.png',
                    width: 200,
                    opacity: const AlwaysStoppedAnimation(0.7),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppLocalizations.of(context)!.typeAnyToSearch,
                    style: TextStyle(
                      color: isDark ? Colors.grey[600] : Colors.grey[400],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(bottom: 20),
            itemCount: state.searchResults.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final result = state.searchResults[index];

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
                clipBehavior: Clip.hardEdge,
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  clipBehavior: Clip.antiAlias,
                  child: CupertinoContextMenu(
                    actions: [
                      CupertinoContextMenuAction(
                        onPressed: () async {
                          Navigator.pop(context);
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => UpdateInput(inputItem: result),
                            ),
                          );
                          if (context.mounted) {
                            context.read<SearchCubit>().refresh();
                          }
                        },
                        trailingIcon: Icons.edit,
                        child: Text(AppLocalizations.of(context)!.slideEdit),
                      ),
                      CupertinoContextMenuAction(
                        isDestructiveAction: true,
                        onPressed: () {
                          Navigator.pop(context);
                          final homeCubit = context.read<HomeCubit>();
                          final searchCubit = context.read<SearchCubit>();
                          ConfirmDeleteDialog.show(
                            context,
                            title: AppLocalizations.of(context)!.slideDelete,
                            content: AppLocalizations.of(
                              context,
                            )!.deleteTransactionConfirm,
                            onConfirm: () async {
                              final id = result.id;
                              searchCubit.removeTransaction(id);
                              await homeCubit.deleteTransaction(id);
                              searchCubit.refresh();
                            },
                          );
                        },
                        trailingIcon: Icons.delete,
                        child: Text(AppLocalizations.of(context)!.slideDelete),
                      ),
                    ],
                    child: TransactionItemTile(
                      transaction: result,
                      isDark: isDark,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => UpdateInput(inputItem: result),
                          ),
                        );
                        if (context.mounted) {
                          context.read<SearchCubit>().refresh();
                        }
                      },
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
