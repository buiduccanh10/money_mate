import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:money_mate/services/locales.dart';
import 'package:money_mate/widget/category/category_manage.dart';
import 'package:money_mate/services/firestore_helper.dart';
import 'package:money_mate/widget/input/input_content.dart';

class cat_update_dialog extends StatefulWidget {
  final cat_item;

  cat_update_dialog({super.key, required this.cat_item});

  @override
  State<cat_update_dialog> createState() => _cat_update_dialogState();
}

class _cat_update_dialogState extends State<cat_update_dialog> {
  TextEditingController icon_controller = TextEditingController();
  TextEditingController cat_controller = TextEditingController();
  bool icon_validate = false;
  bool cat_validate = false;
  firestore_helper db_helper = firestore_helper();
  FToast toast = FToast();
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    icon_controller.text = widget.cat_item['icon'];
    cat_controller.text = widget.cat_item['name'];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool is_dark = Theme.of(context).brightness == Brightness.dark;
    toast.init(context);
    return Builder(builder: (context) {
      return AlertDialog(
        title: Row(
          children: [
            Text(
              LocaleData.update_cat_title.getString(context),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '(${widget.cat_item['name']})',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          ],
        ),
        elevation: 100,
        scrollable: true,
        content: SizedBox(
          width: BouncingScrollSimulation.maxSpringTransferVelocity,
          child: Column(
            children: [
              TextField(
                controller: icon_controller,
                keyboardType: TextInputType.text,
                onTap: () {
                  showEmojiPicker(context);
                },
                decoration: InputDecoration(
                  errorText: icon_validate
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
                  floatingLabelStyle:
                      TextStyle(color: is_dark ? Colors.white : Colors.black),
                  prefixIconColor: Colors.orange,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                keyboardType: TextInputType.text,
                controller: cat_controller,
                decoration: InputDecoration(
                  errorText: cat_validate
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
                  floatingLabelStyle:
                      TextStyle(color: is_dark ? Colors.white : Colors.black),
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
            width: 90,
            decoration: BoxDecoration(
                color: Colors.green,
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.circular(10)),
            child: TextButton(
                onPressed: () {
                  if (icon_controller.text.isEmpty ||
                      cat_controller.text.isEmpty) {
                    setState(() {
                      icon_validate = icon_controller.text.isEmpty;
                      cat_validate = cat_controller.text.isEmpty;
                    });
                  } else {
                    update_cat(
                        uid,
                        widget.cat_item['cat_id'],
                        icon_controller.text,
                        cat_controller.text,
                        widget.cat_item['is_income']);
                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  LocaleData.update.getString(context),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                )),
          )
        ],
      );
    });
  }

  void showEmojiPicker(BuildContext context) {
    bool is_dark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: EmojiPicker(
            textEditingController: icon_controller,
            config: Config(
                checkPlatformCompatibility: true,
                bottomActionBarConfig:
                    const BottomActionBarConfig(enabled: false),
                categoryViewConfig: CategoryViewConfig(
                    showBackspaceButton: true,
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

  Future<void> update_cat(String uid, String cat_id, String icon, String name,
      bool is_income) async {
    try {
      await db_helper.update_category(uid, cat_id, icon, name, is_income);

      if (category_manage.getState() != null &&
          input_content.getState() != null) {
        category_manage.getState()!.fetch_data();
        input_content.getState()!.fetch_data();
      }

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
