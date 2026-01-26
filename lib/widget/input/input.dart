import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:money_mate/services/locales.dart';
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
    return Scaffold(
      body: Stack(children: [
        InputContent(isIncome: isIncome),
        Container(
          height: 100,
          decoration: BoxDecoration(
            gradient: isDark
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 203, 122, 0),
                      Color.fromARGB(255, 0, 112, 204)
                    ],
                  )
                : const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.orange, Colors.blue],
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
                child: CustomSlidingSegmentedControl<int>(
                  initialValue: isIncome ? 1 : 2,
                  fixedWidth: 125,
                  height: 50,
                  children: {
                    1: _buildSegment(
                        context,
                        Icons.arrow_downward,
                        Colors.green,
                        LocaleData.income.getString(context),
                        isIncome),
                    2: _buildSegment(context, Icons.arrow_upward, Colors.red,
                        LocaleData.expense.getString(context), !isIncome),
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
                    setState(() {
                      isIncome = (value == 1);
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _buildSegment(BuildContext context, IconData icon, Color iconColor,
      String label, bool isSelected) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: iconColor),
        Text(
          label,
          style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 16),
        )
      ],
    );
  }
}
