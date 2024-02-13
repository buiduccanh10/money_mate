import 'package:flutter/material.dart';
import 'package:money_mate/services/firestore_helper.dart';
import 'package:shimmer/shimmer.dart';

class home_appbar extends StatefulWidget {
  home_appbar({super.key});

  @override
  State<home_appbar> createState() => _home_appbarState();
}

class _home_appbarState extends State<home_appbar> {
  List<Map<String, dynamic>> expense_categories = [];
  List<Map<String, dynamic>> income_categories = [];
  firestore_helper db_helper = firestore_helper();
  bool is_loading = true;
  bool is_mounted = false;
  int total_income = 0;
  int total_expense = 0;
  int total_saving = 0;

  @override
  void initState() {
    is_mounted = true;
    fetchData();
    super.initState();
  }

  @override
  void dispose() {
    is_mounted = false;
    super.dispose();
  }

  Future<void> fetchData() async {
    List<Map<String, dynamic>> income_temp =
        await db_helper.fetch_data_by_cat(isIncome: true);
    List<Map<String, dynamic>> expense_temp =
        await db_helper.fetch_data_by_cat(isIncome: false);

    if (is_mounted) {
      setState(() {
        income_categories = income_temp;
        expense_categories = expense_temp;
        calculateTotals();
        is_loading = false;
      });
    }
  }

  void calculateTotals() {
    total_income = income_categories
        .map<int>((catItem) => int.parse(catItem['money']))
        .fold<int>(0, (prev, amount) => prev + amount);

    total_expense = expense_categories
        .map<int>((catItem) => int.parse(catItem['money']))
        .fold<int>(0, (prev, amount) => prev + amount);

    total_saving = total_income - total_expense;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
          height: 295,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue, Colors.orange],
            ),
          )),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 70, left: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hi, Bui Duc Canh',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Row(
                  children: [
                    Text(
                      '11/2023',
                      style: TextStyle(
                          color: Color.fromARGB(255, 220, 220, 220),
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: Color.fromARGB(255, 220, 220, 220),
                      size: 30,
                    )
                  ],
                ),
                Shimmer.fromColors(
                  baseColor: Colors.white,
                  direction: ShimmerDirection.rtl,
                  period: Duration(seconds: 3),
                  highlightColor: Colors.grey,
                  child: Text(
                    '${total_saving} đ',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w700),
                  ),
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 30),
            child: CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/avt.jpeg'),
            ),
          )
        ],
      ),
      Padding(
        padding: const EdgeInsets.only(top: 230),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 6,
                    blurRadius: 9,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            '+ ${total_income} đ',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        const Icon(
                          Icons.arrow_downward_sharp,
                          color: Colors.green,
                        )
                      ],
                    ),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Income',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 25,
            ),
            Container(
              height: 100,
              width: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 6,
                    blurRadius: 9,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            '- ${total_expense} đ',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        const Icon(
                          Icons.arrow_upward_sharp,
                          color: Colors.red,
                        )
                      ],
                    ),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Expense',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      )
    ]);
  }
}
