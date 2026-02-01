import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_mate/l10n/app_localizations.dart';
import 'package:money_mate/widget/input/input_content.dart';

class Input extends StatefulWidget {
  const Input({super.key});

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  bool isIncome = false;

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    // STYLE_GUIDE: AppBar Gradient
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

    // STYLE_GUIDE: State Colors
    final incomeColor = const Color(0xFF00C853);
    final expenseColor = const Color(0xFFFF3D00);

    return Scaffold(
      body: Stack(
        children: [
          InputContent(isIncome: isIncome),
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
                    child: CustomSlidingSegmentedControl<int>(
                      initialValue: isIncome ? 1 : 2,
                      fixedWidth: 125,
                      height: 50,
                      children: {
                        1: _buildSegment(
                          context,
                          Icons.arrow_downward,
                          isIncome ? Colors.white : incomeColor,
                          AppLocalizations.of(context)!.income,
                          isIncome,
                        ),
                        2: _buildSegment(
                          context,
                          Icons.arrow_upward,
                          !isIncome ? Colors.white : expenseColor,
                          AppLocalizations.of(context)!.expense,
                          !isIncome,
                        ),
                      },
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      thumbDecoration: BoxDecoration(
                        gradient: isDark
                            ? LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: isIncome
                                    ? [
                                        const Color(0xFF0F2027),
                                        const Color(0xFF2C5364),
                                      ]
                                    : [
                                        const Color(0xFF434343),
                                        const Color(0xFF000000),
                                      ],
                              )
                            : null,
                        color: isDark
                            ? null
                            : (isIncome ? incomeColor : expenseColor),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? Colors.black.withValues(alpha: 0.3)
                                : (isIncome ? incomeColor : expenseColor)
                                      .withValues(alpha: 0.4),
                            blurRadius: 8.0,
                            offset: const Offset(0.0, 4.0),
                          ),
                        ],
                      ),
                      curve: Curves.easeOutCubic,
                      duration: const Duration(milliseconds: 300),
                      onValueChanged: (value) {
                        setState(() {
                          isIncome = (value == 1);
                        });
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
