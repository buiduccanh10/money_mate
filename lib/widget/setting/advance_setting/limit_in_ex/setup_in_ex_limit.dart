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
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settingLimitTitle),
        actions: [
          IconButton(
              onPressed: () => _confirmRestoreAll(context),
              icon: const Icon(Icons.restore_page, color: Colors.red))
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
                child: Text(AppLocalizations.of(context)!.noSetUpYet));
          }

          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              return _buildSlidableItem(context, isDark, cat, locale);
            },
          );
        },
      ),
    );
  }

  Widget _buildSlidableItem(BuildContext context, bool isDark,
      CategoryResponseDto cat, String locale) {
    final formatter = NumberFormat.simpleCurrency(locale: locale);
    final limit = cat.limit ?? 0.0;
    final formatMoney = formatter.format(limit);

    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => _showLimitDialog(cat),
            foregroundColor: Colors.blue,
            icon: Icons.edit,
            label: AppLocalizations.of(context)!.slideEdit,
          ),
          SlidableAction(
            onPressed: (_) =>
                context.read<CategoryCubit>().restoreLimit(cat.id),
            foregroundColor: Colors.red,
            icon: Icons.restore,
            label: AppLocalizations.of(context)!.restoreLimit,
          ),
        ],
      ),
      child: ListTile(
        onTap: () => _showLimitDialog(cat),
        leading: CircleAvatar(
          backgroundColor: Colors
              .primaries[Random().nextInt(Colors.primaries.length)]
              .withValues(alpha: 0.2),
          child: Text(cat.icon, style: const TextStyle(fontSize: 24)),
        ),
        title:
            Text(cat.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(
          limit > 0 ? formatMoney : AppLocalizations.of(context)!.noLimit,
          style:
              const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
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
        title: Text(AppLocalizations.of(context)!.restoreLimit),
        content: Text(AppLocalizations.of(context)!.confirm),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancel)),
          TextButton(
            onPressed: () {
              context.read<CategoryCubit>().restoreAllLimits();
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.confirm,
                style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerList(bool isDark) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: isDark ? Colors.grey[700]! : Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListTile(
          leading: const CircleAvatar(backgroundColor: Colors.white),
          title: Container(height: 15, color: Colors.white),
          trailing: Container(width: 50, height: 15, color: Colors.white),
        ),
      ),
    );
  }
}
