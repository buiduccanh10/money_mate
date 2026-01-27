import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:money_mate/bloc/category/category_cubit.dart';
import 'package:money_mate/bloc/category/category_state.dart';
import 'package:money_mate/widget/category/cat_add_dialog.dart';
import 'package:money_mate/widget/category/cat_update_dialog.dart';
import 'package:money_mate/data/network/swagger/generated/money_mate_api.swagger.dart';
import 'package:shimmer/shimmer.dart';
import 'package:money_mate/l10n/app_localizations.dart';

class CategoryManage extends StatefulWidget {
  final bool isIncome;
  const CategoryManage({super.key, required this.isIncome});

  @override
  State<CategoryManage> createState() => _CategoryManageState();
}

class _CategoryManageState extends State<CategoryManage> {
  @override
  void initState() {
    super.initState();
    context.read<CategoryCubit>().fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

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
        title: Text(
          widget.isIncome
              ? AppLocalizations.of(context)!.inCategoryManageAppbar
              : AppLocalizations.of(context)!.exCategoryManageAppbar,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        leading: const BackButton(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () => _confirmDeleteAll(context),
            icon: const Icon(
              Icons.delete_sweep,
              color: Colors.redAccent,
              size: 28,
            ),
          ),
        ],
        centerTitle: true,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 15),
        child: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return CatAddDialog(isIncome: widget.isIncome);
              },
            );
          },
          backgroundColor: const Color.fromARGB(255, 63, 148, 66),
          child: const Icon(Icons.add, color: Colors.white, size: 35),
        ),
      ),
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          final categories = widget.isIncome
              ? state.incomeCategories
              : state.expenseCategories;

          if (state.status == CategoryStatus.loading && categories.isEmpty) {
            return _buildShimmerList();
          }

          if (categories.isEmpty) {
            return Center(child: Text(AppLocalizations.of(context)!.noCatYet));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final catItem = categories[index];
              return _buildSlidableItem(catItem, context);
            },
          );
        },
      ),
    );
  }

  Widget _buildSlidableItem(CategoryResponseDto catItem, BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            backgroundColor: Colors.transparent,
            onPressed: (context) => _showUpdateDialog(catItem),
            foregroundColor: Colors.blue,
            icon: Icons.edit,
            label: AppLocalizations.of(context)!.slideEdit,
          ),
          SlidableAction(
            backgroundColor: Colors.transparent,
            onPressed: (context) =>
                context.read<CategoryCubit>().deleteCategory(catItem.id),
            foregroundColor: Colors.red,
            icon: Icons.delete,
            label: AppLocalizations.of(context)!.slideDelete,
          ),
        ],
      ),
      child: ListTile(
        onTap: () => _showUpdateDialog(catItem),
        leading: Text(catItem.icon, style: const TextStyle(fontSize: 28)),
        title: Text(catItem.name, style: const TextStyle(fontSize: 18)),
        trailing: const Icon(Icons.navigate_next),
      ),
    );
  }

  void _showUpdateDialog(CategoryResponseDto catItem) {
    showDialog(
      context: context,
      builder: (_) => CatUpdateDialog(catItem: catItem),
    );
  }

  void _confirmDeleteAll(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          widget.isIncome
              ? AppLocalizations.of(context)!.inDeleteAllTitle
              : AppLocalizations.of(context)!.exDeleteAllTitle,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              context.read<CategoryCubit>().deleteAllCategories(
                widget.isIncome,
              );
              Navigator.pop(context);
            },
            child: Text(
              AppLocalizations.of(context)!.confirm,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: 10,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          height: 50,
          color: Colors.white,
        ),
      ),
    );
  }
}
