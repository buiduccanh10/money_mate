import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:money_mate/services/firestore_helper.dart';
import 'package:money_mate/services/locales.dart';
import 'package:money_mate/view_model/input_view_model.dart';
import 'package:money_mate/widget/category/cat_update_dialog.dart';
import 'package:provider/provider.dart';

class category_view_model with ChangeNotifier {
  TextEditingController icon_controller = TextEditingController();
  TextEditingController cat_controller = TextEditingController();
  bool icon_validate = false;
  bool cat_validate = false;
  firestore_helper db_helper = firestore_helper();
  FToast toast = FToast();
  final uid = FirebaseAuth.instance.currentUser!.uid;
  List<Map<String, dynamic>> data = [];
  bool is_loading = true;

  //cat manage
  Future<void> fetch_data(is_income) async {
    List<Map<String, dynamic>> temp =
        await db_helper.fetch_categories(uid, is_income);

    data = temp;
    is_loading = false;
    notifyListeners();
  }

  void edit_cat(Map<String, dynamic> cat_item, context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return cat_update_dialog(
            cat_item: cat_item,
          );
        });
  }

  void delete_cat(int index, String uid, context) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection("category")
          .doc(data[index]['cat_id'])
          .delete();

      data.removeAt(index);
      var input_vm = Provider.of<input_view_model>(context, listen: false);
      input_vm.fetch_data();

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
    } catch (error) {
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

  void delete_all_category(context, is_income) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(
              is_income
                  ? LocaleData.in_delete_all_title.getString(context)
                  : LocaleData.ex_delete_all_title.getString(context),
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  LocaleData.cancel.getString(context),
                ),
              ),
              CupertinoDialogAction(
                  isDestructiveAction: true,
                  onPressed: () async {
                    await db_helper
                        .delete_all_category(uid, is_income)
                        .then((value) => toast.showToast(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.green,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Icon(Icons.check),
                                    Text(LocaleData.toast_delete_success
                                        .getString(context)),
                                  ],
                                ),
                              ),
                              gravity: ToastGravity.CENTER,
                              toastDuration: const Duration(seconds: 2),
                            ))
                        .then((value) => Navigator.of(context).pop())
                        .then((value) {
                      fetch_data(is_income);
                      var input_vm =
                          Provider.of<input_view_model>(context, listen: false);
                      input_vm.fetch_data();
                    });
                  },
                  child: Text(
                    LocaleData.confirm.getString(context),
                  )),
            ],
          );
        });
  }

  //cat add
  Future<void> add_category(
      String icon, String name, bool is_income, context) async {
    if (icon_controller.text.isEmpty || cat_controller.text.isEmpty) {
      icon_validate = icon_controller.text.isEmpty;
      cat_validate = cat_controller.text.isEmpty;
      notifyListeners();
    } else {
      try {
        await db_helper.add_category(uid, icon, name, is_income);

        fetch_data(is_income);
        await Provider.of<input_view_model>(context, listen: false)
            .fetch_data();

        icon_controller.clear();
        cat_controller.clear();

        notifyListeners();

        Navigator.of(context).pop();

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

  Future<void> update_cat(String uid, String cat_id, String icon, String name,
      bool is_income, context) async {
    if (icon_controller.text.isEmpty || cat_controller.text.isEmpty) {
      icon_validate = icon_controller.text.isEmpty;
      cat_validate = cat_controller.text.isEmpty;
      notifyListeners();
    } else {
      try {
        await db_helper.update_category(uid, cat_id, icon, name, is_income);

        fetch_data(is_income);
        await Provider.of<input_view_model>(context, listen: false).fetch_data();

        icon_controller.clear();
        cat_controller.clear();

        notifyListeners();

        Navigator.of(context).pop();

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
