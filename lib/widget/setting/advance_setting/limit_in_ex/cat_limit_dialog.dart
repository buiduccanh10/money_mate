import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:money_mate/services/currency_format.dart';
import 'package:money_mate/services/locales.dart';
import 'package:money_mate/view_model/category_view_model.dart';
import 'package:money_mate/view_model/setting_view_model.dart';
import 'package:money_mate/widget/category/category_manage.dart';
import 'package:money_mate/services/firestore_helper.dart';
import 'package:money_mate/widget/input/input_content.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

typedef void cat_callback();

class cat_limit_dialog extends StatefulWidget {
  String cat_id;
  String cat_name;
  double limit;
  cat_limit_dialog({
    super.key,
    required this.cat_id,
    required this.cat_name,
    required this.limit,
  });

  @override
  State<cat_limit_dialog> createState() => _cat_limit_dialogState();
}

class _cat_limit_dialogState extends State<cat_limit_dialog> {
  @override
  void initState() {
    var set_vm = Provider.of<setting_view_model>(context, listen: false);
    final money_update = NumberFormat("###,###,###", "vi_VN");
    set_vm.limit_controller.text =
        set_vm.localization.currentLocale.toString() == 'vi'
            ? money_update.format(widget.limit)
            : (widget.limit.toString());

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool is_dark = Theme.of(context).brightness == Brightness.dark;
    return Consumer<setting_view_model>(
      builder: (BuildContext context, set_vm, Widget? child) {
        set_vm.toast.init(context);
        return Builder(builder: (context) {
          return AlertDialog(
            title: Text(
              "${LocaleData.limit_dialog.getString(context)}: ${widget.cat_name}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            elevation: 100,
            scrollable: true,
            content: SizedBox(
              width: BouncingScrollSimulation.maxSpringTransferVelocity,
              child: TextField(
                keyboardType:
                    set_vm.localization.currentLocale.toString() == 'vi'
                        ? const TextInputType.numberWithOptions(decimal: false)
                        : const TextInputType.numberWithOptions(decimal: true),
                controller: set_vm.limit_controller,
                inputFormatters:
                    set_vm.localization.currentLocale.toString() == 'vi'
                        ? [
                            FilteringTextInputFormatter.digitsOnly,
                            currency_format(),
                          ]
                        : [],
                decoration: InputDecoration(
                  // errorText: set_vm.limit_controller
                  //     ? LocaleData.cat_name_validator.getString(context)
                  //     : null,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10)),
                  label: Text(
                    LocaleData.input_money.getString(context),
                  ),
                  labelStyle: TextStyle(color: Colors.grey.withOpacity(1)),
                  floatingLabelStyle:
                      TextStyle(color: is_dark ? Colors.white : Colors.black),
                  prefixIcon: const Icon(Icons.money_off),
                  prefixIconColor: Colors.green,
                ),
              ),
            ),
            actions: [
              Container(
                width: 80,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      LocaleData.cancel.getString(context),
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 127, 127, 127)),
                    )),
              ),
              Container(
                width: 80,
                decoration: BoxDecoration(
                    color: Colors.green,
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(10)),
                child: TextButton(
                    onPressed: () {
                      set_vm.handle_limit(widget.cat_id);
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      LocaleData.input_save.getString(context),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    )),
              )
            ],
          );
        });
      },
    );
  }
}
