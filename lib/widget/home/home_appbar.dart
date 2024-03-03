import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:datepicker_dropdown/order_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:money_mate/services/firestore_helper.dart';
import 'package:money_mate/services/locales.dart';
import 'package:money_mate/widget/home/home_list_item.dart';
import 'package:shimmer/shimmer.dart';

class home_appbar extends StatefulWidget {
  static final home_appbar_globalkey = GlobalKey<_home_appbarState>();

  static _home_appbarState? getState() {
    return home_appbar_globalkey.currentState;
  }

  home_appbar() : super(key: home_appbar.home_appbar_globalkey);

  @override
  State<home_appbar> createState() => _home_appbarState();
}

class _home_appbarState extends State<home_appbar> {
  var month = DateTime.now().month;
  var year = DateTime.now().year;
  String formattedDate = '';
  List<Map<String, dynamic>> expense_categories = [];
  List<Map<String, dynamic>> income_categories = [];
  firestore_helper db_helper = firestore_helper();
  bool is_loading = true;
  bool is_mounted = false;
  double total_income = 0;
  double total_expense = 0;
  double total_saving = 0;
  String? user_name;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final localization = FlutterLocalization.instance;

  @override
  void initState() {
    formattedDate = getMonthYearString(month, year);
    is_mounted = true;
    fetchData();
    fetchUserName();
    super.initState();
  }

  @override
  void dispose() {
    is_mounted = false;
    super.dispose();
  }

  String getMonthYearString(int month, int year) {
    final DateTime dateTime = DateTime(year, month);
    final DateFormat formatter = DateFormat('MMMM yyyy');
    return formatter.format(dateTime);
  }

  Future<void> fetchUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        user_name = user.email;
      });
    }
  }

  Future<void> fetchData() async {
    List<Map<String, dynamic>> income_temp = await db_helper
        .fetch_data_cat_bymonth(uid, formattedDate, isIncome: true);
    List<Map<String, dynamic>> expense_temp = await db_helper
        .fetch_data_cat_bymonth(uid, formattedDate, isIncome: false);

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
        .map<double>((catItem) => (catItem['money']))
        .fold<double>(0, (prev, amount) => prev + amount);

    total_expense = expense_categories
        .map<double>((catItem) => (catItem['money']))
        .fold<double>(0, (prev, amount) => prev + amount);

    total_saving =
        double.parse((total_income - total_expense).toStringAsFixed(2));
  }

  @override
  Widget build(BuildContext context) {
    bool is_dark = Theme.of(context).brightness == Brightness.dark;

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    var formatter = NumberFormat.simpleCurrency(
        locale: localization.currentLocale.toString(), decimalDigits: 0);

    String format_total = formatter.format(total_saving);
    String format_income = formatter.format(total_income);
    String format_expense = formatter.format(total_expense);
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
                            '${LocaleData.hello_home_appbar.getString(context)}${user_name}',
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
                            selectedMonth: month,
                            selectedYear: year,
                            boxDecoration: BoxDecoration(
                                color: is_dark
                                    ? Colors.grey[700]
                                    : Colors.grey[100],
                                borderRadius: BorderRadius.circular(10)),
                            inputDecoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            textStyle: TextStyle(
                                color: is_dark ? Colors.white : Colors.black),
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.grey,
                              size: 30,
                            ),
                            onChangedMonth: (newMonth) {
                              setState(() {
                                month = int.parse(newMonth!);
                                formattedDate = getMonthYearString(month, year);
                                fetchData();
                                home_list_item.getState()!.fetch_data_list();
                              });
                            },
                            onChangedYear: (newYear) {
                              setState(() {
                                year = int.parse(newYear!);
                                formattedDate = getMonthYearString(month, year);
                                fetchData();
                                home_list_item.getState()!.fetch_data_list();
                              });
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
                                  fontSize: 30, fontWeight: FontWeight.w700),
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
                                color: is_dark ? Colors.white : Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleData.income.getString(context),
                          style: TextStyle(
                              fontSize: 16,
                              color: is_dark ? Colors.white : Colors.grey,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_downward_sharp,
                          color: is_dark ? Colors.greenAccent : Colors.green,
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
                                color: is_dark ? Colors.white : Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleData.expense.getString(context),
                          style: TextStyle(
                              fontSize: 16,
                              color: is_dark ? Colors.white : Colors.grey,
                              fontWeight: FontWeight.w700),
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
  }
}
