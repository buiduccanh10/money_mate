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

typedef void cat_callback();

class cat_add_dialog extends StatefulWidget {
  bool is_income;
  cat_add_dialog({super.key, required this.is_income});

  @override
  State<cat_add_dialog> createState() => _cat_add_dialogState();
}

class _cat_add_dialogState extends State<cat_add_dialog> {
  TextEditingController icon_controller = TextEditingController();
  TextEditingController cat_controller = TextEditingController();
  bool icon_validate = false;
  bool cat_validate = false;
  firestore_helper db_helper = firestore_helper();
  FToast? toast;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    toast = FToast();
    toast!.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
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
                readOnly: true,
                controller: icon_controller,
                keyboardType: TextInputType.text,
                onTap: () {
                  showEmojiPicker(context);
                },
                decoration: InputDecoration(
                  errorText: icon_validate ? 'Please choose an icon' : null,
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
                  prefixIconColor: Colors.orange,
                  suffixIcon: TextButton(
                    onPressed: () {
                      setState(() {
                        icon_controller.clear();
                      });
                    },
                    child: const Icon(
                      Icons.clear,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                keyboardType: TextInputType.text,
                controller: cat_controller,
                decoration: InputDecoration(
                  errorText: cat_validate ? 'Please enter name of icon' : null,
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
                  floatingLabelStyle: const TextStyle(color: Colors.black),
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
                  if (icon_controller.text.isEmpty ||
                      cat_controller.text.isEmpty) {
                    setState(() {
                      icon_validate = icon_controller.text.isEmpty;
                      cat_validate = cat_controller.text.isEmpty;
                    });
                  } else {
                    add_category(icon_controller.text, cat_controller.text,
                        widget.is_income);
                    Navigator.of(context).pop();
                  }
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
  }

  void showEmojiPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: EmojiPicker(
            textEditingController: icon_controller,
            config: const Config(
              columns: 7,
              bgColor: Colors.white,
              emojiSizeMax: 28,
              verticalSpacing: 0,
              horizontalSpacing: 0,
              enableSkinTones: true,
              gridPadding: EdgeInsets.zero,
              initCategory: Category.RECENT,
              recentTabBehavior: RecentTabBehavior.RECENT,
              recentsLimit: 28,
              noRecents: Text(
                'No Recents',
                style: TextStyle(fontSize: 20, color: Colors.black26),
                textAlign: TextAlign.center,
              ),
              loadingIndicator: SizedBox.shrink(),
              tabIndicatorAnimDuration: kTabScrollDuration,
              categoryIcons: CategoryIcons(),
              buttonMode: ButtonMode.MATERIAL,
            ),
          ),
        );
      },
    );
  }

  Future<void> add_category(String icon, String name, bool is_income) async {
    try {
      await db_helper.add_category(uid, icon, name, is_income);

      if (category_manage.getState() != null &&
          input_content.getState() != null) {
        category_manage.getState()!.fetchData();
        input_content.getState()!.fetchData();
      }

      toast!.showToast(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.green,
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.check),
              Text("Create success!"),
            ],
          ),
        ),
        gravity: ToastGravity.CENTER,
        toastDuration: const Duration(seconds: 2),
      );
    } catch (err) {
      toast!.showToast(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.red,
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.do_disturb),
              Text("Create fail!"),
            ],
          ),
        ),
        gravity: ToastGravity.CENTER,
        toastDuration: const Duration(seconds: 2),
      );
    }
  }
}
