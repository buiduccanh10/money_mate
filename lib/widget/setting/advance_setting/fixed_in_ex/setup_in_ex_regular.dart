import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:money_mate/services/locales.dart';
import 'package:money_mate/bloc/schedule/schedule_cubit.dart';
import 'package:money_mate/bloc/schedule/schedule_state.dart';
import 'package:money_mate/widget/setting/advance_setting/fixed_in_ex/start_setup.dart';
import 'package:shimmer/shimmer.dart';

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
    final locale = FlutterLocalization.instance.currentLocale.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleData.fixed_in_ex.getString(context)),
        actions: [
          IconButton(
              onPressed: () => _confirmDeleteAll(context),
              icon: const Icon(Icons.delete_sweep, color: Colors.red))
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
                child: Text(LocaleData.no_set_up_yet.getString(context)));
          }

          return ListView.builder(
            itemCount: state.schedules.length,
            itemBuilder: (context, index) {
              final schedule = state.schedules[index];
              return _buildScheduleItem(context, isDark, schedule, locale);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const StartSetup())),
        backgroundColor: const Color.fromARGB(255, 63, 148, 66),
        child: const Icon(Icons.add, color: Colors.white, size: 35),
      ),
    );
  }

  Widget _buildScheduleItem(BuildContext context, bool isDark,
      Map<String, dynamic> schedule, String locale) {
    final formatter = NumberFormat.simpleCurrency(locale: locale);
    final formatMoney = formatter.format(schedule['money']);

    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) {
              final id = int.tryParse(schedule['id'].toString());
              if (id != null) context.read<ScheduleCubit>().deleteSchedule(id);
            },
            foregroundColor: Colors.red,
            icon: Icons.delete,
            label: LocaleData.slide_delete.getString(context),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors
              .primaries[Random().nextInt(Colors.primaries.length)]
              .withOpacity(0.2),
          child: Text(schedule['icon'] ?? '📅',
              style: const TextStyle(fontSize: 24)),
        ),
        title: Text('${schedule['description']} (${schedule['option']})',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(schedule['date']),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${schedule['is_income'] ? '+' : '-'} $formatMoney',
              style: TextStyle(
                  color: schedule['is_income'] ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold),
            ),
            Text(schedule['name'] ?? '',
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteAll(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(LocaleData.slide_delete.getString(context)),
        content: Text(LocaleData.confirm.getString(context)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(LocaleData.cancel.getString(context))),
          TextButton(
            onPressed: () {
              context.read<ScheduleCubit>().deleteAllSchedules();
              Navigator.pop(context);
            },
            child: Text(LocaleData.confirm.getString(context),
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
          subtitle: Container(height: 10, color: Colors.white, width: 100),
          trailing: Container(width: 50, height: 15, color: Colors.white),
        ),
      ),
    );
  }
}
