import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class cat_add_dialog extends StatefulWidget {
  const cat_add_dialog({super.key});

  @override
  State<cat_add_dialog> createState() => _cat_add_dialogState();
}

class _cat_add_dialogState extends State<cat_add_dialog> {
  TextEditingController icon_controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text(
        'Add a new category',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
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
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10)),
                label: const Text('Choose an icon'),
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
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10)),
                label: const Text('Category name'),
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
              child: const Text(
                'Cancel',
                style: TextStyle(
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
              onPressed: () {},
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              )),
        )
      ],
    );
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
}
