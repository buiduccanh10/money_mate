import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:money_mate/services/firestore_helper.dart';
import 'package:money_mate/services/locales.dart';
import 'package:money_mate/view_model/home_view_model.dart';
import 'package:money_mate/widget/input/update_input.dart';
import 'package:provider/provider.dart';

class search_view_model with ChangeNotifier {
  final db_helper = firestore_helper();
  final uid = FirebaseAuth.instance.currentUser!.uid;
  List<Map<String, dynamic>> results = [];
  List<Map<String, dynamic>> cat_list = [];
  bool is_loading = true;
  FToast toast = FToast();
  Timer? timer;
  final localization = FlutterLocalization.instance;

  search_view_model() {
    fetch_categories();
  }

  Future<void> search(String uid, String query, context) async {
    List<Map<String, dynamic>> temp = await db_helper.search(uid, query);
    if (temp.isEmpty) {
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
              const Icon(Icons.search_off_outlined),
              Text(LocaleData.toast_not_found.getString(context)),
            ],
          ),
        ),
        gravity: ToastGravity.CENTER,
        toastDuration: const Duration(seconds: 3),
      );
    }

    results = temp;
    is_loading = false;
    notifyListeners();
  }

  Future<void> search_by_cat(String uid, String cat_id, context) async {
    List<Map<String, dynamic>> temp =
        await db_helper.search_by_cat(uid, cat_id);

    if (temp.isEmpty) {
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
              const Icon(Icons.search_off_outlined),
              Text(LocaleData.toast_not_found.getString(context)),
            ],
          ),
        ),
        gravity: ToastGravity.CENTER,
        toastDuration: const Duration(seconds: 3),
      );
    }

    results = temp;
    is_loading = false;
    notifyListeners();
  }

  void handle_edit(Map<String, dynamic> input_item, context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                update_input(input_item: input_item)));
  }

  void handle_delete(String input_id, String uid, int index, context) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection("input")
          .doc(input_id)
          .delete();

      results.removeAt(index);
      var home_vm = Provider.of<home_view_model>(context, listen: false);
      home_vm.init();
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
              const Icon(Icons.delete),
              Text(LocaleData.toast_delete_success.getString(context)),
            ],
          ),
        ),
        gravity: ToastGravity.CENTER,
        toastDuration: const Duration(seconds: 3),
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
        toastDuration: const Duration(seconds: 3),
      );
    }
  }

  Future<void> fetch_categories() async {
    List<Map<String, dynamic>> temp = await db_helper.fetch_all_categories(uid);

    cat_list = temp;
    is_loading = false;
    notifyListeners();
  }

  void updated_item(Map<String, dynamic> updated_item) {
    int index = results.indexWhere((item) => item['id'] == updated_item['id']);
    if (index != -1) {
      results[index] = updated_item;
    }
    notifyListeners();
  }
}
