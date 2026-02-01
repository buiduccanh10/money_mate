import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_mate/l10n/app_localizations.dart';
import 'package:money_mate/bloc/chart/chart_cubit.dart';
import 'package:money_mate/bloc/chart/chart_state.dart';
import 'package:money_mate/widget/chart/chart_widget.dart';

class Chart extends StatefulWidget {
  const Chart({super.key});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    final headerGradient = LinearGradient(
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

    final activeColor = const Color(0xFF4364F7);

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF5F7FA),
      body: Stack(
        children: [
          const ChartWidget(),
          Container(
            height: 115,
            decoration: BoxDecoration(
              gradient: headerGradient,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: BlocBuilder<ChartCubit, ChartState>(
                      buildWhen: (previous, current) =>
                          previous.isMonthly != current.isMonthly,
                      builder: (context, state) {
                        return CustomSlidingSegmentedControl<int>(
                          initialValue: state.isMonthly ? 1 : 2,
                          fixedWidth: 125,
                          height: 50,
                          children: {
                            1: _buildSegment(
                              context,
                              Icons.calendar_month_rounded,
                              state.isMonthly ? Colors.white : activeColor,
                              AppLocalizations.of(context)!.switchMonthly,
                              state.isMonthly,
                            ),
                            2: _buildSegment(
                              context,
                              Icons.calendar_today_rounded,
                              !state.isMonthly ? Colors.white : activeColor,
                              AppLocalizations.of(context)!.switchYearly,
                              !state.isMonthly,
                            ),
                          },
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1E1E1E)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          thumbDecoration: BoxDecoration(
                            gradient: isDark
                                ? const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF0F2027),
                                      Color(0xFF2C5364),
                                    ],
                                  )
                                : null,
                            color: isDark ? null : activeColor,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: isDark
                                    ? Colors.black.withValues(alpha: 0.3)
                                    : activeColor.withValues(alpha: 0.4),
                                blurRadius: 8.0,
                                offset: const Offset(0.0, 4.0),
                              ),
                            ],
                          ),
                          curve: Curves.easeOutCubic,
                          duration: const Duration(milliseconds: 300),
                          onValueChanged: (value) {
                            context.read<ChartCubit>().toggleView(value == 1);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegment(
    BuildContext context,
    IconData icon,
    Color iconColor,
    String label,
    bool isSelected,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected
                ? Colors.white
                : (isDark ? iconColor.withValues(alpha: 0.7) : iconColor),
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.white70 : Colors.black),
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
