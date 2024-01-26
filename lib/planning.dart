import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_mate/category_manage.dart';
import 'package:money_mate/model/outcome_cat.dart';
import 'package:money_mate/widget/planning_content.dart';

class planning extends StatefulWidget {
  planning({super.key});

  @override
  State<planning> createState() => _planningState();
}

class _planningState extends State<planning>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  bool? is_income;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    // ..forward()
    // ..repeat(reverse: true);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reset();
      }
    });

    is_income = true;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        planning_content(
          is_income: is_income!,
        ),
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
                    1: Row(
                      children: [
                        const Icon(
                          Icons.arrow_downward,
                          color: Colors.green,
                        ),
                        Text(
                          'Income',
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
                          'Spending',
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
      floatingActionButton: SizedBox(
        width: 110,
        height: 60,
        child: FloatingActionButton.extended(
          backgroundColor: const Color.fromARGB(255, 63, 148, 66),
          onPressed: () {
            controller.forward();
          },
          label: Row(
            children: [
              AnimatedIcon(
                icon: AnimatedIcons.add_event,
                size: 35,
                color: Colors.white,
                progress: animation,
              ),
              const SizedBox(
                width: 5,
              ),
              const Text(
                'Save',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
