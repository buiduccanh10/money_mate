import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:money_mate/services/locales.dart';
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
    return Scaffold(
      body: Stack(children: [
        const ChartWidget(),
        Container(
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      const Color.fromARGB(255, 0, 112, 204),
                      const Color.fromARGB(255, 203, 122, 0)
                    ]
                  : [Colors.orange, Colors.blue],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 65),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                  boxShadow: isDark
                      ? null
                      : [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.3),
                            spreadRadius: 6,
                            blurRadius: 9,
                            offset: const Offset(0, 5),
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
                        1: Text(
                          LocaleData.switchMonthly.getString(context),
                          style: TextStyle(
                              color:
                                  state.isMonthly ? Colors.black : Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ),
                        2: Text(
                          LocaleData.switchYearly.getString(context),
                          style: TextStyle(
                              color: !state.isMonthly
                                  ? Colors.black
                                  : Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ),
                      },
                      decoration: BoxDecoration(
                        color: CupertinoColors.lightBackgroundGray,
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.orange[400]!, Colors.blue[400]!],
                        ),
                      ),
                      thumbDecoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .3),
                            blurRadius: 4.0,
                            spreadRadius: 1.0,
                            offset: const Offset(0.0, 2.0),
                          ),
                        ],
                      ),
                      curve: Curves.ease,
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
      ]),
    );
  }
}
