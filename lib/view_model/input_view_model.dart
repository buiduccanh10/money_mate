import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:money_mate/services/firestore_helper.dart';
import 'package:money_mate/services/locales.dart';
import 'package:money_mate/view_model/chart_view_model.dart';
import 'package:money_mate/view_model/home_view_model.dart';
import 'package:money_mate/view_model/search_view_model.dart';
import 'package:money_mate/widget/category/category_manage.dart';
import 'package:money_mate/widget/input/input.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class input_view_model with ChangeNotifier {
  List<Map<String, dynamic>> expense_categories = [];
  List<Map<String, dynamic>> income_categories = [];
  DateRangePickerController date_controller = DateRangePickerController();
  TextEditingController description_controller = TextEditingController();
  TextEditingController money_controller = TextEditingController();
  String? cat_id;
  firestore_helper db_helper = firestore_helper();
  int? selectedIndex;
  double scale = 1.0;
  bool des_validate = false;
  bool money_validate = false;
  bool is_loading = true;
  FToast toast = FToast();
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final localization = FlutterLocalization.instance;

  input_view_model() {
    fetch_data();
  }

  Future<void> fetch_data() async {
    List<Map<String, dynamic>> income_temp =
        await db_helper.fetch_categories(uid, true);

    List<Map<String, dynamic>> expense_temp =
        await db_helper.fetch_categories(uid, false);

    income_categories = income_temp;
    expense_categories = expense_temp;
    is_loading = false;

    notifyListeners();
  }

  Future<void> addInput(DateTime? date, String description, String money,
      String? cat_id, context) async {
    if (description_controller.text.isEmpty ||
        money_controller.text.isEmpty ||
        (selectedIndex == null || cat_id == null)) {
      des_validate = description_controller.text.isEmpty;
      money_validate = money_controller.text.isEmpty;

      notifyListeners();

      toast.showToast(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.orange,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(Icons.warning),
              Text(LocaleData.cat_validator.getString(context)),
            ],
          ),
        ),
        gravity: ToastGravity.CENTER,
        toastDuration: const Duration(seconds: 3),
      );
    } else {
      try {
        String formatDate;
        String formatMoney = localization.currentLocale.toString() == 'vi'
            ? money.replaceAll('.', '')
            : money.replaceAll(',', '.');
        double moneyFinal = double.parse(formatMoney);
        if (date_controller.selectedDate == null) {
          formatDate =
              DateFormat('dd/MM/yyyy').format(date_controller.displayDate!);
          await db_helper.add_input(
              uid, formatDate, description, moneyFinal, cat_id);
        } else {
          formatDate =
              DateFormat('dd/MM/yyyy').format(date_controller.selectedDate!);
          await db_helper.add_input(
              uid, formatDate, description, moneyFinal, cat_id);
        }

        description_controller.clear();
        money_controller.clear();
        selectedIndex = null;
        this.cat_id = null;

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
                Text(LocaleData.toast_add_success.getString(context)),
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
                Text(LocaleData.toast_add_fail.getString(context)),
              ],
            ),
          ),
          gravity: ToastGravity.CENTER,
          toastDuration: const Duration(seconds: 2),
        );
      }
    }
  }

  Future<void> update_input(
      String id,
      DateTime? date,
      String old_date,
      bool is_income,
      String description,
      String money,
      String cat_id,
      context) async {
    if (description_controller.text.isEmpty || money_controller.text.isEmpty) {
      des_validate = description_controller.text.isEmpty;
      money_validate = money_controller.text.isEmpty;
      notifyListeners();
    } else {
      try {
        String format_date;
        String format_money = localization.currentLocale.toString() == 'vi'
            ? money.replaceAll('.', '')
            : money.replaceAll(',', '.');
        double money_final = double.parse(format_money);
        if (date_controller.selectedDate == null) {
          await db_helper
              .update_input(uid, id, old_date, description, is_income,
                  money_final, cat_id)
              .then((value) => Navigator.pop(context));
        } else {
          format_date =
              DateFormat('dd/MM/yyyy').format(date_controller.selectedDate!);
          await db_helper
              .update_input(uid, id, format_date, description, is_income,
                  money_final, cat_id)
              .then((value) => Navigator.pop(context));
        }

        description_controller.clear();
        money_controller.clear();
        selectedIndex = null;
        this.cat_id = null;

        var home_vm = Provider.of<home_view_model>(context, listen: false);
        home_vm.init();
        var search_vm = Provider.of<search_view_model>(context, listen: false);
        search_vm.search_by_cat(uid, cat_id, context);

        if (Navigator.canPop(context)) {
          var chart_vm = Provider.of<chart_view_model>(context, listen: false);
          chart_vm.fecth_data_bymonth();
          Navigator.of(context).pop();
        }

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
                Text(LocaleData.toast_update_success.getString(context)),
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
                Text(LocaleData.toast_update_fail.getString(context)),
              ],
            ),
          ),
          gravity: ToastGravity.CENTER,
          toastDuration: const Duration(seconds: 2),
        );
      }
    }
  }
}
