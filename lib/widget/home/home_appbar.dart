import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:money_mate/l10n/app_localizations.dart';
import 'package:money_mate/bloc/home/home_cubit.dart';
import 'package:money_mate/bloc/home/home_state.dart';
import 'package:shimmer/shimmer.dart';
import 'package:money_mate/widget/common/month_year_picker_sheet.dart';

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
    context.read<HomeCubit>().changeMonth(DateTime.now().month);
    context.read<HomeCubit>().changeYear(DateTime.now().year);
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final locale = Localizations.localeOf(context).toString();
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        var formatter = NumberFormat.simpleCurrency(locale: locale);

        String formatTotal = formatter.format(state.totalSaving);
        String formatIncome = formatter.format(state.totalIncome);
        String formatExpense = formatter.format(state.totalExpense);

        return SizedBox(
          height: 335,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Modern Gradient Background (Height 280)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 280,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
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
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black26
                            : Colors.blue.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      // Greeting & Name
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.helloHomeAppbar,
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  state.userName ?? "",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          // Date Picker in a Glass-like container
                          Container(
                            width: width * 0.35,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                              ),
                            ),
                            child: InkWell(
                              onTap: () => MonthYearPickerSheet.show(
                                context,
                                initialMonth: state.month,
                                initialYear: state.year,
                                onConfirm: (month, year) {
                                  context.read<HomeCubit>().changeMonth(month);
                                  context.read<HomeCubit>().changeYear(year);
                                },
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.calendar_month,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      state.formattedDate,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      // Total Balance Section
                      Row(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.totalSaving,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Shimmer.fromColors(
                            direction: ShimmerDirection.rtl,
                            period: const Duration(seconds: 3),
                            baseColor: Colors.white,
                            highlightColor: const Color.fromARGB(
                              255,
                              139,
                              181,
                              201,
                            ),
                            // enabled: state.status == HomeStatus.loading,
                            child: Text(
                              formatTotal,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Floating Income/Expense Cards
              Positioned(
                top: 230,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildTotalCard(
                          context,
                          isDark,
                          formatIncome,
                          AppLocalizations.of(context)!.income,
                          Icons.arrow_downward_rounded,
                          isDark ? Colors.greenAccent : const Color(0xFF00C853),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTotalCard(
                          context,
                          isDark,
                          formatExpense,
                          AppLocalizations.of(context)!.expense,
                          Icons.arrow_upward_rounded,
                          isDark ? Colors.redAccent : const Color(0xFFFF3D00),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTotalCard(
    BuildContext context,
    bool isDark,
    String amount,
    String label,
    IconData icon,
    Color iconColor,
  ) {
    return Container(
      height: 100, // Fixed reasonable height
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            amount,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
