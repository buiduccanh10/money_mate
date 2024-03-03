import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:money_mate/services/locales.dart';
import 'package:money_mate/widget/category/category_manage.dart';
import 'package:money_mate/widget/input/input_content.dart';

class input extends StatefulWidget {
  const input({super.key});

  @override
  State<input> createState() => _inputState();
}

class _inputState extends State<input> {
  bool? is_income;

  @override
  void initState() {
    super.initState();

    is_income = true;
  }

  @override
  Widget build(BuildContext context) {
    bool is_dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Stack(children: [
        input_content(
          is_income: is_income!,
        ),
        Container(
          height: 100,
          decoration: BoxDecoration(
            gradient: is_dark
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 203, 122, 0),
                      Color.fromARGB(255, 0, 112, 204),
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
                  boxShadow: is_dark
                      ? null
                      : [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 6,
                            blurRadius: 9,
                            offset: const Offset(0, 5),
                          ),
                        ],
                ),
                child: CustomSlidingSegmentedControl<int>(
                  initialValue: 1,
                  fixedWidth: 125,
                  height: 50,
                  children: {
                    1: Row(
                      children: [
                        const Icon(
                          Icons.arrow_downward,
                          color: Colors.green,
                        ),
                        Text(
                          LocaleData.income.getString(context),
                          style: TextStyle(
                              color: is_income! ? Colors.black : Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        )
                      ],
                    ),
                    2: Row(
                      children: [
                        const Icon(
                          Icons.arrow_upward,
                          color: Colors.red,
                        ),
                        Text(
                          LocaleData.expense.getString(context),
                          style: TextStyle(
                              color: is_income! ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        )
                      ],
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
                        color: Colors.black.withOpacity(.3),
                        blurRadius: 4.0,
                        spreadRadius: 1.0,
                        offset: const Offset(
                          0.0,
                          2.0,
                        ),
                      ),
                    ],
                  ),
                  curve: Curves.ease,
                  onValueChanged: (value) {
                    if (value == 1) {
                      setState(() {
                        is_income = true;
                      });
                    }
                    if (value == 2) {
                      setState(() {
                        is_income = false;
                      });
                    }
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
