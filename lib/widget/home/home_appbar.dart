import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:money_mate/services/locales.dart';
import 'package:money_mate/bloc/home/home_cubit.dart';
import 'package:money_mate/bloc/home/home_state.dart';
import 'package:shimmer/shimmer.dart';

class HomeAppbar extends StatefulWidget {
  const HomeAppbar({super.key});

  @override
  State<HomeAppbar> createState() => _HomeAppbarState();
}

class _HomeAppbarState extends State<HomeAppbar> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().fetchData();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final locale = FlutterLocalization.instance.currentLocale.toString();

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        var formatter = NumberFormat.simpleCurrency(locale: locale);

        String formatTotal = formatter.format(state.totalSaving);
        String formatIncome = formatter.format(state.totalIncome);
        String formatExpense = formatter.format(state.totalExpense);

        return Stack(children: [
          Container(
            height: 280,
            decoration: BoxDecoration(
              gradient: isDark
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromARGB(255, 0, 112, 204),
                        Color.fromARGB(255, 203, 122, 0)
                      ],
                    )
                  : const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.blue, Colors.orange],
                    ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(left: width * 0.06),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: width * 0.9,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                '${LocaleData.helloHomeAppbar.getString(context)}${state.userName ?? ""}',
                                style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 26.0, bottom: 8),
                            child: SizedBox(
                                height: 50,
                                width: width * 0.6,
                                child: DropdownDatePicker(
                                    width: 5,
                                    selectedMonth: state.month,
                                    selectedYear: state.year,
                                    boxDecoration: BoxDecoration(
                                        color: isDark
                                            ? Colors.grey[700]
                                            : Colors.grey[100],
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    inputDecoration: const InputDecoration(
                                        border: InputBorder.none),
                                    textStyle: TextStyle(
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black),
                                    icon: const Icon(Icons.arrow_drop_down,
                                        color: Colors.grey, size: 30),
                                    onChangedMonth: (newMonth) {
                                      if (newMonth != null) {
                                        context
                                            .read<HomeCubit>()
                                            .changeMonth(int.parse(newMonth));
                                      }
                                    },
                                    onChangedYear: (newYear) {
                                      if (newYear != null) {
                                        context
                                            .read<HomeCubit>()
                                            .changeYear(int.parse(newYear));
                                      }
                                    },
                                    showDay: false,
                                    yearFlex: 2,
                                    monthFlex: 3)),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            LocaleData.totalSaving.getString(context),
                            style: const TextStyle(
                                color: Colors.amber,
                                fontSize: 22,
                                fontWeight: FontWeight.w700),
                          ),
                          Shimmer.fromColors(
                            baseColor: Colors.white,
                            direction: ShimmerDirection.rtl,
                            period: const Duration(seconds: 3),
                            highlightColor: Colors.grey,
                            child: Row(
                              children: [
                                Text(
                                  formatTotal,
                                  style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 235),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTotalCard(
                  context,
                  isDark,
                  width,
                  height,
                  formatIncome,
                  LocaleData.income.getString(context),
                  Icons.arrow_downward_sharp,
                  isDark ? Colors.greenAccent : Colors.green,
                ),
                SizedBox(width: width * 0.065),
                _buildTotalCard(
                  context,
                  isDark,
                  width,
                  height,
                  formatExpense,
                  LocaleData.expense.getString(context),
                  Icons.arrow_upward_sharp,
                  isDark ? Colors.redAccent : Colors.red,
                ),
              ],
            ),
          )
        ]);
      },
    );
  }

  Widget _buildTotalCard(
    BuildContext context,
    bool isDark,
    double width,
    double height,
    String amount,
    String label,
    IconData icon,
    Color iconColor,
  ) {
    return Container(
      height: height * 0.11,
      width: width * 0.4,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[700] : Colors.white,
        borderRadius: BorderRadius.circular(10),
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
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                    amount,
                    style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                    overflow: TextOverflow.clip,
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.white : Colors.grey,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: 10),
                Icon(icon, color: iconColor)
              ],
            )
          ],
        ),
      ),
    );
  }
}
