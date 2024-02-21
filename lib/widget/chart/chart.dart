import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_mate/widget/chart/chart_widget.dart';

class chart extends StatefulWidget {
  const chart({super.key});

  @override
  State<chart> createState() => _chartState();
}

class _chartState extends State<chart> {
  int selected_index = 0;
  bool? is_monthly;

  @override
  void initState() {
    is_monthly = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        chart_widget(is_monthly: is_monthly!),
        Container(
          height: 100,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
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
                  boxShadow: [
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
                    1: Text(
                      'Monthly',
                      style: TextStyle(
                          color: is_monthly! ? Colors.black : Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ),
                    2: Text(
                      'Yearly',
                      style: TextStyle(
                          color: is_monthly! ? Colors.white : Colors.black,
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
                        is_monthly = true;
                      });
                    }
                    if (value == 2) {
                      setState(() {
                        is_monthly = false;
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
