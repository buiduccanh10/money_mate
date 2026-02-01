import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:money_mate/l10n/app_localizations.dart';
import 'package:money_mate/bloc/category/category_cubit.dart';
import 'package:money_mate/bloc/category/category_state.dart';
import 'package:money_mate/widget/setting/advance_setting/limit_in_ex/cat_limit_dialog.dart';
import 'package:money_mate/data/network/swagger/generated/money_mate_api.swagger.dart';
import 'package:shimmer/shimmer.dart';

class SetupInExLimit extends StatefulWidget {
  const SetupInExLimit({super.key});

  @override
  State<SetupInExLimit> createState() => _SetupInExLimitState();
}

class _SetupInExLimitState extends State<SetupInExLimit> {
  @override
  void initState() {
    super.initState();
    context.read<CategoryCubit>().fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final locale = Localizations.localeOf(context).toString();

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
          ),
        ),
        title: Text(
          AppLocalizations.of(context)!.settingLimitTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () => _confirmRestoreAll(context),
            icon: const Icon(Icons.restore_page, color: Colors.white),
          ),
        ],
      ),
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          final categories = state.expenseCategories;

          if (state.status == CategoryStatus.loading && categories.isEmpty) {
            return _buildShimmerList(isDark);
          }

          if (categories.isEmpty) {
            return Center(
              child: Text(
                AppLocalizations.of(context)!.noSetUpYet,
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: categories.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final cat = categories[index];
              return _buildSlidableItem(context, isDark, cat, locale);
            },
          );
        },
      ),
    );
  }

  Widget _buildSlidableItem(
    BuildContext context,
    bool isDark,
    CategoryResponseDto cat,
    String locale,
  ) {
    final formatter = NumberFormat.simpleCurrency(locale: locale);
    final limit = cat.limit ?? 0.0;
    final formatMoney = formatter.format(limit);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: Slidable(
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (_) => _showLimitDialog(cat),
                backgroundColor: Colors.blue.withValues(alpha: 0.1),
                foregroundColor: Colors.blue,
                icon: Icons.edit,
                label: AppLocalizations.of(context)!.slideEdit,
              ),
              SlidableAction(
                onPressed: (_) =>
                    context.read<CategoryCubit>().restoreLimit(cat.id),
                backgroundColor: Colors.red.withValues(alpha: 0.1),
                foregroundColor: Colors.red,
                icon: Icons.restore,
                label: AppLocalizations.of(context)!.restoreLimit,
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            onTap: () => _showLimitDialog(cat),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors
                    .primaries[Random().nextInt(Colors.primaries.length)]
                    .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Text(cat.icon, style: const TextStyle(fontSize: 24)),
            ),
            title: Text(
              cat.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            trailing: Text(
              limit > 0 ? formatMoney : AppLocalizations.of(context)!.noLimit,
              style: TextStyle(
                color: limit > 0
                    ? (isDark ? Colors.greenAccent : Colors.green)
                    : Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showLimitDialog(CategoryResponseDto cat) {
    showDialog(
      context: context,
      builder: (_) => CatLimitDialog(
        catId: cat.id,
        catName: cat.name,
        limit: cat.limit ?? 0.0,
      ),
    );
  }

  void _confirmRestoreAll(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(AppLocalizations.of(context)!.restoreLimit),
        content: Text(AppLocalizations.of(context)!.confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<CategoryCubit>().restoreAllLimits();
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

  Widget _buildShimmerList(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
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
