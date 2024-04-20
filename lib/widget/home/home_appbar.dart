import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:datepicker_dropdown/order_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:money_mate/services/firestore_helper.dart';
import 'package:money_mate/services/locales.dart';
import 'package:money_mate/view_model/home_view_model.dart';
import 'package:money_mate/widget/home/home_list_item.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class home_appbar extends StatefulWidget {
  const home_appbar({super.key});

  @override
  State<home_appbar> createState() => _home_appbarState();
}

class _home_appbarState extends State<home_appbar> {
  @override
  void initState() {
    var home_vm = Provider.of<home_view_model>(context, listen: false);
    home_vm.fetch_data();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool is_dark = Theme.of(context).brightness == Brightness.dark;

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Consumer<home_view_model>(
      builder: (BuildContext context, home_vm, Widget? child) {
        var formatter = NumberFormat.simpleCurrency(
            locale: home_vm.localization.currentLocale.toString());

        String format_total = formatter.format(home_vm.total_saving);
        String format_income = formatter.format(home_vm.total_income);
        String format_expense = formatter.format(home_vm.total_expense);
        return Stack(children: [
          Container(
              height: 280,
              decoration: BoxDecoration(
                gradient: is_dark
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
              )),
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
                                '${LocaleData.hello_home_appbar.getString(context)}${home_vm.user_name}',
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
                      Padding(
                        padding: const EdgeInsets.only(top: 26.0, bottom: 8),
                        child: SizedBox(
                            height: 50,
                            width: width * 0.6,
                            child: DropdownDatePicker(
                                width: 5,
                                selectedMonth: home_vm.month,
                                selectedYear: home_vm.year,
                                boxDecoration: BoxDecoration(
                                    color: is_dark
                                        ? Colors.grey[700]
                                        : Colors.grey[100],
                                    borderRadius: BorderRadius.circular(10)),
                                inputDecoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                                textStyle: TextStyle(
                                    color:
                                        is_dark ? Colors.white : Colors.black),
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.grey,
                                  size: 30,
                                ),
                                onChangedMonth: (newMonth) {
                                  home_vm.onChangedMonth(newMonth);
                                },
                                onChangedYear: (newYear) {
                                  home_vm.onChangedYear(newYear);
                                },
                                showDay: false,
                                yearFlex: 2,
                                monthFlex: 3)),
                      ),
                      Row(
                        children: [
                          Text(
                            LocaleData.total_saving.getString(context),
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
                                  '${format_total}',
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
                Container(
                  height: height * 0.11,
                  width: width * 0.4,
                  decoration: BoxDecoration(
                    color: is_dark ? Colors.grey[700] : Colors.white,
                    borderRadius: BorderRadius.circular(10),
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
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                '${format_income}',
                                style: TextStyle(
                                    color:
                                        is_dark ? Colors.white : Colors.black,
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
                                LocaleData.income.getString(context),
                                style: TextStyle(
                                    fontSize: 16,
                                    color: is_dark ? Colors.white : Colors.grey,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.arrow_downward_sharp,
                              color:
                                  is_dark ? Colors.greenAccent : Colors.green,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 0.065,
                ),
                Container(
                  height: height * 0.11,
                  width: width * 0.4,
                  decoration: BoxDecoration(
                    color: is_dark ? Colors.grey[700] : Colors.white,
                    borderRadius: BorderRadius.circular(10),
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
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                '${format_expense}',
                                style: TextStyle(
                                    color:
                                        is_dark ? Colors.white : Colors.black,
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
                                LocaleData.expense.getString(context),
                                style: TextStyle(
                                    fontSize: 16,
                                    color: is_dark ? Colors.white : Colors.grey,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.arrow_upward_sharp,
                              color: is_dark ? Colors.redAccent : Colors.red,
                            )
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
      },
    );
  }

  // String get_month_year_string(int month, int year) {
  //   final DateTime dateTime = DateTime(year, month);
  //   final DateFormat formatter = DateFormat('MMMM yyyy');
  //   return formatter.format(dateTime);
  // }

  // Future<void> fetch_user_name() async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     setState(() {
  //       user_name = user.email;
  //     });
  //   }
  // }

  // Future<void> fetch_data() async {
  //   List<Map<String, dynamic>> income_temp = await db_helper
  //       .fetch_data_cat_bymonth( formattedDate, isIncome: true);
  //   List<Map<String, dynamic>> expense_temp = await db_helper
  //       .fetch_data_cat_bymonth(formattedDate, isIncome: false);

  //   if (is_mounted) {
  //     setState(() {
  //       income_categories = income_temp;
  //       expense_categories = expense_temp;
  //       calculate_totals();
  //       is_loading = false;
  //     });
  //   }
  // }

  // void calculate_totals() {
  //   total_income = income_categories
  //       .map<double>((catItem) => (catItem['money']))
  //       .fold<double>(0, (prev, amount) => prev + amount);

  //   total_expense = expense_categories
  //       .map<double>((catItem) => (catItem['money']))
  //       .fold<double>(0, (prev, amount) => prev + amount);

  //   total_saving =
  //       double.parse((total_income - total_expense).toStringAsFixed(2));
  // }
}
