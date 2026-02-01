import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:money_mate/l10n/app_localizations.dart';
import 'package:money_mate/bloc/schedule/schedule_cubit.dart';
import 'package:money_mate/bloc/schedule/schedule_state.dart';
import 'package:money_mate/widget/setting/advance_setting/fixed_in_ex/start_setup.dart';
import 'package:money_mate/data/network/swagger/generated/money_mate_api.swagger.dart';
import 'package:shimmer/shimmer.dart';
import 'package:money_mate/widget/common/item_action_menu.dart';

class SetupInExRegular extends StatefulWidget {
  const SetupInExRegular({super.key});

  @override
  State<SetupInExRegular> createState() => _SetupInExRegularState();
}

class _SetupInExRegularState extends State<SetupInExRegular> {
  @override
  void initState() {
    super.initState();
    context.read<ScheduleCubit>().fetchSchedules();
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
          AppLocalizations.of(context)!.fixedInEx,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () => _confirmDeleteAll(context),
            icon: const Icon(Icons.delete_sweep, color: Colors.white),
          ),
        ],
      ),
      body: BlocBuilder<ScheduleCubit, ScheduleState>(
        builder: (context, state) {
          if (state.status == ScheduleStatus.loading &&
              state.schedules.isEmpty) {
            return _buildShimmerList(isDark);
          }

          if (state.schedules.isEmpty) {
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
            itemCount: state.schedules.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final schedule = state.schedules[index];
              return _buildScheduleItem(context, isDark, schedule, locale);
            },
          );
        },
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const StartSetup()),
          ),
          backgroundColor: const Color(0xFF4CAF50),
          elevation: 0,
          highlightElevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  Widget _buildScheduleItem(
    BuildContext context,
    bool isDark,
    ScheduleResponseDto schedule,
    String locale,
  ) {
    final formatter = NumberFormat.simpleCurrency(locale: locale);
    final formatMoney = formatter.format(schedule.money);

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
                onPressed: (_) {
                  context.read<ScheduleCubit>().deleteSchedule(
                    schedule.id.toString(),
                  );
                },
                backgroundColor: Colors.red.withValues(alpha: 0.1),
                foregroundColor: Colors.red,
                icon: Icons.delete,
                label: AppLocalizations.of(context)!.slideDelete,
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            onLongPress: () {
              ItemActionMenu.show(
                context,
                onEdit: () {},
                onDelete: () {
                  context.read<ScheduleCubit>().deleteSchedule(
                    schedule.id.toString(),
                  );
                },
              );
            },
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors
                    .primaries[Random().nextInt(Colors.primaries.length)]
                    .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Text(schedule.icon, style: const TextStyle(fontSize: 24)),
            ),
            title: Text(
              '${schedule.description} (${schedule.option.name})',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            subtitle: Text(
              schedule.date,
              style: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                fontSize: 13,
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${schedule.isIncome ? '+' : '-'} $formatMoney',
                  style: TextStyle(
                    color: schedule.isIncome ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  schedule.name,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmDeleteAll(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(AppLocalizations.of(context)!.slideDelete),
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
              context.read<ScheduleCubit>().deleteAllSchedules();
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
