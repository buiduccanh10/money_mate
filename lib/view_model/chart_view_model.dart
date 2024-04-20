import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:money_mate/services/firestore_helper.dart';
import 'package:money_mate/services/locales.dart';
import 'package:money_mate/widget/chart/chart_item_detail.dart';
import 'package:money_mate/widget/input/update_input.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

class chart_view_model with ChangeNotifier {
  firestore_helper db_helper = firestore_helper();
  List<Map<String, dynamic>> expense_categories = [];
  List<Map<String, dynamic>> income_categories = [];
  late TooltipBehavior tooltipBehavior;
  String month_year_formated = '';
  bool? is_income;
  bool is_loading = true;
  double total_income = 0;
  double total_expense = 0;
  double total_saving = 0;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  var month = DateTime.now().month;
  var year = DateTime.now().year;
  final localization = FlutterLocalization.instance;
  List<Map<String, dynamic>> data = [];
  FToast toast = FToast();

  chart_view_model() {
    is_income = true;
    month_year_formated = get_month_year_string(month, year);
    tooltipBehavior = TooltipBehavior(enable: true);
  }

  
  Future<void> details_cat_item(String cat_id, String date, bool is_income,
      bool is_monthly, context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => chart_item_detail(
          cat_id: cat_id,
          date: date,
          is_income: is_income,
          is_monthly: is_monthly,
        ),
      ),
    );
  }

  String get_month_year_string(int month, int year) {
    final DateTime dateTime = DateTime(year, month);
    final DateFormat formatter = DateFormat('MMMM yyyy');
    return formatter.format(dateTime);
  }

  void is_month(is_monthly) {
    if (is_monthly) {
      fecth_data_bymonth();
    } else {
      fecth_data_byyear();
    }
  }

  void onChangedMonth(newMonth) {
    month = int.parse(newMonth!);
    month_year_formated = get_month_year_string(month, year);
    fecth_data_bymonth();
    notifyListeners();
  }

  void onChangedMonthYear(newYear) {
    year = int.parse(newYear!);
    month_year_formated = get_month_year_string(month, year);
    fecth_data_bymonth();
    notifyListeners();
  }

  void onChangedYear(newYear) {
    year = int.parse(newYear!);
    fecth_data_byyear();
    notifyListeners();
  }

  Future<void> fecth_data_bymonth() async {
    List<Map<String, dynamic>> income_temp = await db_helper
        .fetch_data_cat_bymonth(uid, month_year_formated, isIncome: true);
    List<Map<String, dynamic>> expense_temp = await db_helper
        .fetch_data_cat_bymonth(uid, month_year_formated, isIncome: false);

    income_categories = groupBy(income_temp, (item) => '${item['cat_id']}')
        .values
        .map((items) => {
              'icon': items.first['icon'],
              'name': items.first['name'],
              'is_income': true,
              'cat_id': items.first['cat_id'],
              'money': items
                  .map<double>((item) => item['money'])
                  .fold<double>(0, (prev, amount) => prev + amount),
            })
        .toList();
    expense_categories = groupBy(expense_temp, (item) => '${item['cat_id']}')
        .values
        .map((items) => {
              'icon': items.first['icon'],
              'name': items.first['name'],
              'is_income': true,
              'cat_id': items.first['cat_id'],
              'money': items
                  .map<double>((item) => item['money'])
                  .fold<double>(0, (prev, amount) => prev + amount),
            })
        .toList();
    calculate_totals();
    is_loading = false;
    notifyListeners();
  }

  Future<void> fecth_data_byyear() async {
    List<Map<String, dynamic>> income_temp = await db_helper
        .fetch_data_cat_byyear(uid, year.toString(), isIncome: true);

    List<Map<String, dynamic>> expense_temp = await db_helper
        .fetch_data_cat_byyear(uid, year.toString(), isIncome: false);

    income_categories = groupBy(income_temp, (item) => '${item['cat_id']}')
        .values
        .map((items) => {
              'icon': items.first['icon'],
              'name': items.first['name'],
              'cat_id': items.first['cat_id'],
              'money': items
                  .map<double>((item) => item['money'])
                  .fold<double>(0, (prev, amount) => prev + amount),
            })
        .toList();
    expense_categories = groupBy(expense_temp, (item) => '${item['cat_id']}')
        .values
        .map((items) => {
              'icon': items.first['icon'],
              'name': items.first['name'],
              'cat_id': items.first['cat_id'],
              'money': items
                  .map<double>((item) => item['money'])
                  .fold<double>(0, (prev, amount) => prev + amount),
            })
        .toList();
    calculate_totals();
    is_loading = false;
    notifyListeners();
  }

  void calculate_totals() {
    total_income = income_categories
        .map<double>((catItem) => (catItem['money']))
        .fold<double>(0, (prev, amount) => prev + amount);

    total_expense = expense_categories
        .map<double>((catItem) => (catItem['money']))
        .fold<double>(0, (prev, amount) => prev + amount);

    total_saving =
        double.parse((total_income - total_expense).toStringAsFixed(2));

    notifyListeners();
  }

  // chart detail item

  void handle_edit(
      Map<String, dynamic> input_item, context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                update_input(input_item: input_item)));
  }

  void handle_delete(String input_id, String uid, context) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection("input")
          .doc(input_id)
          .delete();

      data.removeWhere((item) => item['id'] == input_id);

      notifyListeners();

      toast.showToast(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.green,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(Icons.check),
              Text(LocaleData.toast_delete_success.getString(context)),
            ],
          ),
        ),
        gravity: ToastGravity.CENTER,
        toastDuration: const Duration(seconds: 2),
      );
    } catch (err) {
      toast.showToast(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.red,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(Icons.do_disturb),
              Text(LocaleData.toast_delete_fail.getString(context)),
            ],
          ),
        ),
        gravity: ToastGravity.CENTER,
        toastDuration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> fetch_data(uid,
      bool? is_monthly, bool? is_income, String? date, String? cat_id) async {
    List<Map<String, dynamic>> temp = is_monthly!
        ? await db_helper.fetch_input_month_by_cat_id(
            uid,
            date!,
            cat_id!,
            isIncome: is_income!,
          )
        : await db_helper.fetch_input_year_by_cat_id(
            uid,
            date!,
            cat_id!,
            isIncome: is_income!,
          );

    data = temp;
    is_loading = false;
    notifyListeners();
  }

  void updated_item(Map<String, dynamic> updated_item) {
    // fetch_data(updated_item['is_monthly'], updated_item['is_income'],
    //     updated_item['date'], updated_item['cat_id']);
    int index = data.indexWhere((item) => item['id'] == updated_item['id']);
    if (index != -1) {
      data[index] = updated_item;
    }
    notifyListeners();
  }
}
