import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:money_mate/services/locales.dart';
import 'package:money_mate/view_model/category_view_model.dart';
import 'package:money_mate/widget/category/category_manage.dart';
import 'package:money_mate/services/firestore_helper.dart';
import 'package:money_mate/widget/input/input_content.dart';
import 'package:provider/provider.dart';

typedef void cat_callback();

class cat_add_dialog extends StatefulWidget {
  bool is_income;
  cat_add_dialog({super.key, required this.is_income});

  @override
  State<cat_add_dialog> createState() => _cat_add_dialogState();
}

class _cat_add_dialogState extends State<cat_add_dialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool is_dark = Theme.of(context).brightness == Brightness.dark;
    return Consumer<category_view_model>(
      builder: (BuildContext context, cat_vm, Widget? child) {
        cat_vm.toast.init(context);
        return Builder(builder: (context) {
          return AlertDialog(
            title: Text(
              LocaleData.add_cat_dialog_title.getString(context),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            elevation: 100,
            scrollable: true,
            content: SizedBox(
              width: BouncingScrollSimulation.maxSpringTransferVelocity,
              child: Column(
                children: [
                  TextField(
                    controller: cat_vm.icon_controller,
                    keyboardType: TextInputType.text,
                    onTap: () {
                      showEmojiPicker(context);
                    },
                    decoration: InputDecoration(
                      errorText: cat_vm.icon_validate
                          ? LocaleData.cat_icon_validator.getString(context)
                          : null,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10)),
                      label: Text(
                        LocaleData.choose_an_icon.getString(context),
                      ),
                      labelStyle: TextStyle(color: Colors.grey.withOpacity(1)),
                      prefixIcon: const Icon(Icons.insert_emoticon),
                      floatingLabelStyle: TextStyle(
                          color: is_dark ? Colors.white : Colors.black),
                      prefixIconColor: Colors.orange,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    keyboardType: TextInputType.text,
                    controller: cat_vm.cat_controller,
                    decoration: InputDecoration(
                      errorText: cat_vm.cat_validate
                          ? LocaleData.cat_name_validator.getString(context)
                          : null,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10)),
                      label: Text(
                        LocaleData.category_name.getString(context),
                      ),
                      labelStyle: TextStyle(color: Colors.grey.withOpacity(1)),
                      floatingLabelStyle: TextStyle(
                          color: is_dark ? Colors.white : Colors.black),
                      prefixIcon: const Icon(Icons.new_label),
                      prefixIconColor: Colors.blueAccent,
                    ),
                  ),
                ],
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
                      cat_vm.add_category(
                          cat_vm.icon_controller.text,
                          cat_vm.cat_controller.text,
                          widget.is_income,
                          context);
                      
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

  void showEmojiPicker(BuildContext context) {
    bool is_dark = Theme.of(context).brightness == Brightness.dark;
    var cat_vm = Provider.of<category_view_model>(context, listen: false);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: EmojiPicker(
            textEditingController: cat_vm.icon_controller,
            config: Config(
                checkPlatformCompatibility: true,
                bottomActionBarConfig:
                    const BottomActionBarConfig(enabled: false),
                categoryViewConfig: CategoryViewConfig(
                    backgroundColor: is_dark ? Colors.black : Colors.white,
                    backspaceColor: Colors.red),
                emojiViewConfig: EmojiViewConfig(
                    backgroundColor: is_dark ? Colors.black : Colors.white,
                    noRecents: DefaultNoRecentsWidget,
                    loadingIndicator: const SizedBox.shrink(),
                    buttonMode: ButtonMode.MATERIAL)),
          ),
        );
      },
    );
  }
}
