import 'dart:ui';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:money_mate/model/income_cat.dart';
import 'package:money_mate/model/outcome_cat.dart';
import 'package:money_mate/widget/category/cat_add_dialog.dart';
import 'package:money_mate/widget/category/cat_edit.dart';

class category_manage extends StatefulWidget {
  bool is_income;
  category_manage({super.key, required this.is_income});

  @override
  State<category_manage> createState() => _category_manageState();
}

class _category_manageState extends State<category_manage> {
  List<outcome_cat> outcome_categories = outcome_cat.list_outcome_cat();
  List<income_cat> income_categories = income_cat.list_income_cat();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 15),
        child: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return cat_add_dialog(is_income : widget.is_income);
                });
          },
          backgroundColor: const Color.fromARGB(255, 63, 148, 66),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 35,
          ),
        ),
      ),
      body: Stack(children: [
        Container(
          height: 110,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue, Colors.orange],
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                  padding: const EdgeInsets.all(15),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  )),
              const SizedBox(
                width: 30,
              ),
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  'Swipe right to take action',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: widget.is_income
                      ? income_categories.length
                      : outcome_categories.length,
                  itemBuilder: (BuildContext context, int index) {
                    final cat_item = widget.is_income
                        ? income_categories[index]
                        : outcome_categories[index];

                    return Slidable(
                      closeOnScroll: true,
                      startActionPane:
                          const ActionPane(motion: BehindMotion(), children: [
                        SlidableAction(
                          onPressed: _handleEdit,
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.green,
                          icon: Icons.edit,
                          label: 'Edit',
                        ),
                        SlidableAction(
                          onPressed: _handleDelete,
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.red,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ]),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => cat_edit(cat_id : (cat_item as dynamic).cat_id)),
                          );
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.black, width: 0))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      (cat_item as dynamic).icon!,
                                      style: const TextStyle(fontSize: 28),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      (cat_item as dynamic).name!,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                                const Icon(Icons.navigate_next)
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            )),
      ]),
    );
  }
}

void _handleEdit(BuildContext context) {
  // Implement your edit logic here
}
void _handleDelete(BuildContext context) {
  // Implement your edit logic here
}
