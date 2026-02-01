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
import 'package:money_mate/widget/common/confirm_delete_dialog.dart';
import 'package:money_mate/widget/common/item_action_menu.dart';

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

    final appBarGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isDark
          ? [
              const Color(0xFF0F2027),
              const Color(0xFF203A43),
              const Color(0xFF2C5364),
            ]
          : [const Color(0xFF4364F7), const Color(0xFF6FB1FC)],
    );

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF5F7FA),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: appBarGradient,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
        ),
        title: Text(
          widget.isIncome
              ? AppLocalizations.of(context)!.inCategoryManageAppbar
              : AppLocalizations.of(context)!.exCategoryManageAppbar,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const BackButton(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () => _confirmDeleteAll(context),
            icon: const Icon(Icons.delete_sweep, color: Colors.white, size: 28),
          ),
        ],
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CatAddDialog(isIncome: widget.isIncome);
            },
          );
        },
        backgroundColor: const Color.fromARGB(255, 63, 148, 66),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          final categories = widget.isIncome
              ? state.incomeCategories
              : state.expenseCategories;

          if (state.status == CategoryStatus.loading && categories.isEmpty) {
            return _buildShimmerList(isDark);
          }

          if (categories.isEmpty) {
            return Center(child: Text(AppLocalizations.of(context)!.noCatYet));
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            itemCount: categories.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final catItem = categories[index];
              return _buildSlidableItem(catItem, context, isDark);
            },
          );
        },
      ),
    );
  }

  Widget _buildSlidableItem(
    CategoryResponseDto catItem,
    BuildContext context,
    bool isDark,
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
      clipBehavior: Clip.hardEdge,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: Slidable(
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                backgroundColor: Colors.blue.withValues(alpha: 0.1),
                onPressed: (context) => _showUpdateDialog(catItem),
                foregroundColor: Colors.blue,
                icon: Icons.edit,
                // label: AppLocalizations.of(context)!.slideEdit,
              ),
              SlidableAction(
                backgroundColor: Colors.red.withValues(alpha: 0.1),
                onPressed: (context) {
                  ConfirmDeleteDialog.show(
                    context,
                    title: AppLocalizations.of(context)!.slideDelete,
                    content: AppLocalizations.of(
                      context,
                    )!.deleteCategoryConfirm,
                    onConfirm: () => context
                        .read<CategoryCubit>()
                        .deleteCategory(catItem.id),
                  );
                },
                foregroundColor: Colors.red,
                icon: Icons.delete,
                // label: AppLocalizations.of(context)!.slideDelete,
              ),
            ],
          ),
          child: ListTile(
            onTap: () => _showUpdateDialog(catItem),
            onLongPress: () {
              ItemActionMenu.show(
                context,
                onEdit: () => _showUpdateDialog(catItem),
                onDelete: () {
                  ConfirmDeleteDialog.show(
                    context,
                    title: AppLocalizations.of(context)!.slideDelete,
                    content: AppLocalizations.of(
                      context,
                    )!.deleteCategoryConfirm,
                    onConfirm: () => context
                        .read<CategoryCubit>()
                        .deleteCategory(catItem.id),
                  );
                },
              );
            },
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.circular(20),
            // ),
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.grey.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Text(catItem.icon, style: const TextStyle(fontSize: 24)),
            ),
            title: Text(
              catItem.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isDark ? Colors.white54 : Colors.grey,
            ),
          ),
        ),
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
    final title = widget.isIncome
        ? AppLocalizations.of(context)!.inDeleteAllTitle
        : AppLocalizations.of(context)!.exDeleteAllTitle;

    ConfirmDeleteDialog.show(
      context,
      title: title,
      content: title,
      onConfirm: () {
        context.read<CategoryCubit>().deleteAllCategories(widget.isIncome);
      },
    );
  }

  Widget _buildShimmerList(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Shimmer.fromColors(
          baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
          highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}
